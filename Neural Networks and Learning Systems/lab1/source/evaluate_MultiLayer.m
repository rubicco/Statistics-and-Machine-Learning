%% This script will help you test out your single layer neural network code

%% Select which data to use:

% 1 = dot cloud 1
% 2 = dot cloud 2
% 3 = dot cloud 3
% 4 = OCR data

dataSetNr = 3 ; % Change this to load new data 

[X, D, L] = loadDataSet( dataSetNr );

%% Select a subset of the training features

numBins = 2; % Number of Bins you want to devide your data into
numSamplesPerLabelPerBin = inf; % Number of samples per label per bin, set to inf for max number (total number is numLabels*numSamplesPerBin)
selectAtRandom = true; % true = select features at random, false = select the first features

[ Xt, Dt, Lt ] = selectTrainingSamples(X, D, L, numSamplesPerLabelPerBin, numBins, selectAtRandom );

% Note: Xt, Dt, Lt will be cell arrays, to extract a bin from them use i.e.
% XBin1 = Xt{1};
%% Modify the X Matrices so that a bias is added

% The Training Data
Xtraining = [ones(1,size(Xt{1},2)); Xt{1}];

% The Test Data
Xtest = [ones(1,size(Xt{2},2)); Xt{2}];



%% Train your single layer network
% Note: You nned to modify trainSingleLayer() in order to train the network
% 2nd dataset: hidden=7; numIteration=10000; learningRate=0.001
% 3rd dataset: hidden=10; numIteration=40000 | 39770; learningRate=0.01
% 4rd dataset: h"idden=40; numIteration=4600; learningRate=0.01
numHidden = 32; % Change this, Number of hidde neurons 
numIterations = 3500; % Change this, Numner of iterations (Epochs)
learningRate = 0.01; % Change this, Your learningrate
W0 = (rand(numHidden, size(Xtraining,1))*2-1)/10; % Change this, Initiate your weight matrix W
V0 = (rand(length(unique(L)), numHidden + 1)*2-1)/10; % Change this, Initiate your weight matrix V

%
tic
[W,V, trainingError, testError ] = trainMultiLayer(Xtraining,Dt{1},Xtest,Dt{2}, W0,V0,numIterations, learningRate );
trainingTime = toc;
%% Plot errors
figure(1101)
clf
[mErr, mErrInd] = min(testError);
plot(trainingError,'k','linewidth',1.5)
hold on
plot(testError,'r','linewidth',1.5)
plot(mErrInd,mErr,'bo','linewidth',1.5)
hold off
title('Training and Test Errors, Multi-Layer')
legend('Training Error','Test Error','Min Test Error')

%% Calculate The Confusion Matrix and the Accuracy of the Evaluation Data
% Note: you have to modify the calcConfusionMatrix() function yourselfs.

[ Y, LMultiLayerTraining ] = runMultiLayer(Xtraining, W, V);
tic
[ Y, LMultiLayerTest ] = runMultiLayer(Xtest, W,V);
classificationTime = toc/length(Xtest);
% The confucionMatrix
cM = calcConfusionMatrix( LMultiLayerTest, Lt{2});

% The accuracy
acc = calcAccuracy(cM);

display(['Time spent training: ' num2str(trainingTime) ' sec'])
display(['Time spent calssifying 1 feature vector: ' num2str(classificationTime) ' sec'])
display(['Accuracy: ' num2str(acc)])

%% Plot classifications
% Note: You do not need to change this code.

if dataSetNr < 4
    plotResultMultiLayer(W,V,Xtraining,Lt{1},LMultiLayerTraining,Xtest,Lt{2},LMultiLayerTest)
else
    plotResultsOCR( Xtest, Lt{2}, LMultiLayerTest )
end


%% Non-Generalized Multilinear Neural Network

train_indexes = [1:500];
test_indexes = [501:2000];


Xtraining = X(: , train_indexes);
Dtraining = D(:, train_indexes);
Ltraining = L(train_indexes, :);

Xtest = X(: , test_indexes);
Dtest = D(:, test_indexes);
Ltest = L(test_indexes, :);

% % % Adding Biases
% The Training Data
Xtraining = [ones(1,size(Xtraining,2)); Xtraining];

% The Test Data
Xtest = [ones(1,size(Xtest,2)); Xtest];


%% Training Non-Generalized Neural Network

numHidden = 30; % Change this, Number of hidde neurons 
numIterations = 5000; % Change this, Numner of iterations (Epochs)
learningRate = 0.17; % Change this, Your learningrate
W0 = (rand(numHidden, size(Xtraining,1))*2-1)/10; % Change this, Initiate your weight matrix W
V0 = (rand(length(unique(L)), numHidden + 1)*2-1)/10; % Change this, Initiate your weight matrix V

%
tic
[W,V, trainingError, testError ] = trainMultiLayer(Xtraining,Dtraining,Xtest,Dtest, W0,V0,numIterations, learningRate );
trainingTime = toc;

%% Non-Generalized Plot errors

figure(1101)
clf
[mErr, mErrInd] = min(testError);
plot(trainingError,'k','linewidth',1.5)
hold on
plot(testError,'r','linewidth',1.5)
plot(mErrInd,mErr,'bo','linewidth',1.5)
hold off
title('Training and Test Errors, Multi-Layer')
legend('Training Error','Test Error','Min Test Error')

%% Non-Generalized Calculate Accuracy

[ Y, LMultiLayerTraining ] = runMultiLayer(Xtraining, W, V);
tic
[ Y, LMultiLayerTest ] = runMultiLayer(Xtest, W,V);
classificationTime = toc/length(Xtest);
% The confucionMatrix
cM = calcConfusionMatrix( LMultiLayerTest, Ltest);

% The accuracy
acc = calcAccuracy(cM);

display(['Time spent training: ' num2str(trainingTime) ' sec'])
display(['Time spent calssifying 1 feature vector: ' num2str(classificationTime) ' sec'])
display(['Accuracy: ' num2str(acc)])

%% Non-Generalized Plot The Result

plotResultMultiLayer(W,V,Xtraining, Ltraining,LMultiLayerTraining,Xtest,Ltest,LMultiLayerTest)
