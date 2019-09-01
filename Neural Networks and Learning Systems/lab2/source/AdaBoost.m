%% Hyper-parameters
%  You will need to change these. Start with a small number and increase
%  when your algorithm is working.

% Number of randomized Haar-features
nbrHaarFeatures = 100;
% Number of training images, will be evenly split between faces and
% non-faces. (Should be even.)
nbrTrainImages = 1000;
% Number of weak classifiers
nbrWeakClassifiers = 100;

% set seed in order to not changing analysis
rng(123)

%% Load face and non-face data and plot a few examples
%  Note that the data sets are shuffled each time you run the script.
%  This is to prevent a solution that is tailored to specific images.

load faces;
load nonfaces;
faces = double(faces(:,:,randperm(size(faces,3))));
nonfaces = double(nonfaces(:,:,randperm(size(nonfaces,3))));

figure(1);
colormap gray;
for k=1:25
    subplot(5,5,k), imagesc(faces(:,:,10*k));
    axis image;
    axis off;
end

figure(2);
colormap gray;
for k=1:25
    subplot(5,5,k), imagesc(nonfaces(:,:,10*k));
    axis image;
    axis off;
end

%% Generate Haar feature masks
haarFeatureMasks = GenerateHaarFeatureMasks(nbrHaarFeatures);

figure(3);
colormap gray;
for k = 1:25
    subplot(5,5,k),imagesc(haarFeatureMasks(:,:,k),[-1 2]);
    axis image;
    axis off;
end

%% Create image sets (do NOT modify!)

% Create a training data set with examples from both classes.
% Non-faces = class label y=-1, faces = class label y=1
trainImages = cat(3,faces(:,:,1:nbrTrainImages/2),nonfaces(:,:,1:nbrTrainImages/2));
xTrain = ExtractHaarFeatures(trainImages,haarFeatureMasks);
yTrain = [ones(1,nbrTrainImages/2), -ones(1,nbrTrainImages/2)];

% Create a test data set, using the rest of the faces and non-faces.
testImages  = cat(3,faces(:,:,(nbrTrainImages/2+1):end),...
                    nonfaces(:,:,(nbrTrainImages/2+1):end));
xTest = ExtractHaarFeatures(testImages,haarFeatureMasks);
yTest = [ones(1,size(faces,3)-nbrTrainImages/2), -ones(1,size(nonfaces,3)-nbrTrainImages/2)];

% Variable for the number of test-data.
nbrTestImages = length(yTest);

%% Implement the AdaBoost training here
%  Use your implementation of WeakClassifier and WeakClassifierError
T_size = nbrTrainImages + 2;
% set the thresholds in order to test all possible thresholds and combinations.
thresholds = xTrain;
thresholds(:,((T_size-1):T_size)) = [max(thresholds')+10;min(thresholds')-10]';
% initialize first parameters
D = ones(nbrTrainImages,1)/nbrTrainImages;
alpha = zeros(1, nbrWeakClassifiers);
optimal_pred = zeros(nbrWeakClassifiers,nbrTrainImages);
optimal_thres = zeros(1,nbrWeakClassifiers);
optimal_feature =  zeros(1,nbrWeakClassifiers);
optimal_error = zeros(1,nbrWeakClassifiers);
optimal_P = zeros(1,nbrWeakClassifiers);
% Iteration for all weak classifiers
for t = 1:nbrWeakClassifiers
    error_min = inf;
    %loop for finding optimal feature and threshold
    for i = 1:nbrHaarFeatures
        %loop for optimal threshold
        for j = 1:T_size
            P = 1;
            pred = WeakClassifier(thresholds(i,j),P,xTrain(i,:));
            error = WeakClassifierError(pred,D,yTrain);
            
            %keep error between 0 and 0.5
            if error >0.5
               P = -1;
               error = 1-error;
            end
            
            % condition for storing mininum error
            if error < error_min
                %store all the optimal values
                error_min = error;
                optimal_error(t) = error;
                optimal_thres(t) = thresholds(i,j);
                optimal_pred(t,:) = WeakClassifier(optimal_thres(t),P,xTrain(i,:));
                optimal_P(t) = P;
                optimal_feature(t) = i;
                

            end

        end
    end
    
    % calculate alpha in order to update weights
    alpha(t) =  log((1-optimal_error(t))/optimal_error(t))/2;
    
    %update weights for the new classifier
    D = D.*exp(-alpha(t)*(yTrain.*optimal_pred(t,:)))';
    D = D/sum(D);
    
end

% strong classifier with 100 weak classifier
H = alpha*optimal_pred;
   
final_pred = sign(H);    
 
%% Evaluate your strong classifier here
%  You can evaluate on the training data if you want, but you CANNOT use
%  this as a performance metric since it is biased. You MUST use the test
%  data to truly evaluate the strong classifier.

% In this chunk we keep 100 weak classifiers for strong classifier.
% So we have not chosen weak classifiers yet. We did this after plot.

C = zeros(size(optimal_feature,2),size(yTest,2));

for i = 1:size(optimal_feature,2)
   
    test = xTest(optimal_feature(i),:);
    C(i,:) = WeakClassifier(optimal_thres(i),optimal_P(i),test);
    
end

final_pred = sign(alpha*C);
1 -sum((final_pred ~= yTest))/size(yTest,2)

%% Plot the error of the strong classifier as a function of the number of weak classifiers.
%  Note: you can find this error without re-training with a different
%  number of weak classifiers.

train_error = zeros(1, nbrWeakClassifiers);
test_error = zeros(1, nbrWeakClassifiers);
% iterate all weak classifiers. in this loop when e=3, it means we will
% use first 3 weak classifiers to predict and calculate error.
for e = 1:nbrWeakClassifiers
    C = zeros(e,size(yTest,2));
    T = zeros(e,size(yTrain,2));
    for i = 1:e
        % select only optimal features (columns) in the test data
        test = xTest(optimal_feature(i),:);
        train = xTrain(optimal_feature(i),:);
        C(i,:) = WeakClassifier(optimal_thres(i),optimal_P(i),test);
        T(i,:) = WeakClassifier(optimal_thres(i),optimal_P(i),train);
    end
    final_pred_test = sign(alpha(1:e)*C);
    final_pred_train = sign(alpha(1:e)*T);
    test_error(e) = sum((final_pred_test ~= yTest))/size(yTest,2);
    train_error(e) = sum((final_pred_train ~= yTrain))/size(yTrain,2);
    
end
 
plot(1:nbrWeakClassifiers, 1-test_error)
hold on
plot(1:nbrWeakClassifiers, 1-train_error)
hold off

%% Creating the Strong Classifier

% The plot above we observe after one point performance on test data is
% not changing, but train always increases which means overfitting to the
% training data.
% we can select first 40 minimum weak classifiers to constuct the final
% strong classifier. Because after this point the performance change is 
% really small.

weak_count = 40;

strong_features = optimal_feature(1:weak_count);
strong_thresholds = optimal_thres(1:weak_count);
strong_P = optimal_P(1:weak_count);
strong_alpha = alpha(1:weak_count);

% evaluate this final strong classifier

C = zeros(size(strong_features,2), size(yTest,2));

for i = 1:size(strong_features,2)
    test = xTest(strong_features(i), :);
    C(i,:) = WeakClassifier(strong_thresholds(i), strong_P(i), test);
end

final_pred = sign(strong_alpha*C);
1 - sum(final_pred ~= yTest) / size(yTest,2)


%% Plot some of the misclassified faces and non-faces from the test set

%  Use the subplot command to make nice figures with multiple images.
% Plot for misclassified Faces.
indexes = find(yTest ~= final_pred);
figure(1);
colormap gray;
for k=1:25
    subplot(5,5,k), imagesc(testImages(:,:,indexes(k)));
    axis image;
    axis off;
end

%plot for misclassified non faces
figure(2);
colormap gray;
for k=1:25
    subplot(5,5,k), imagesc(testImages(:,:,indexes(end-k)));
    axis image;
    axis off;
end

%% Plot your choosen Haar-features
%  Use the subplot command to make nice figures with multiple images.

indexes = unique(strong_features);

figure(3);
colormap gray;
for k = 1:30
    subplot(6,5,k),imagesc(haarFeatureMasks(:,:,indexes(k)),[-1 2]);
    axis image;
    axis off;
end


