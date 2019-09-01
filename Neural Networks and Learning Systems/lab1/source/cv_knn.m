function [mean_acc_test, mean_acc_train] = cv_knn(X, D, L, Nfolds, k)

    numBins = Nfolds; % Number of Bins you want to devide your data into
    numSamplesPerLabelPerBin = 100; % Number of samples per label per bin, set to inf for max number (total number is numLabels*numSamplesPerBin)
    selectAtRandom = false; % true = select features at random, false = select the first features

    
    rng(1234567);
    [ Xt, Dt, Lt ] = selectTrainingSamples(X, D, L, numSamplesPerLabelPerBin, numBins, selectAtRandom );



    % create folds array k=numBins
    folds = 1:Nfolds;
    % empty array for rates that we will get in each iteration
    cv_acc_rates_test = zeros(size(folds,2),1);
    cv_acc_rates_train = zeros(size(folds,2),1);
    % iterate folds k=numBins
    for test_index = folds
        test_data = Xt{test_index};
        test_label = Lt{test_index};
        train_data = horzcat(Xt{folds(folds~=test_index)});
        train_label = horzcat(Lt{folds(folds~=test_index)});

        test_kNN = kNN(test_data, k, train_data, train_label);
        train_kNN = kNN(train_data, k, train_data, train_label);

        % The confucionMatrix
        cM_test = calcConfusionMatrix( test_kNN, test_label);
        cM_train = calcConfusionMatrix( train_kNN, train_label);    
        % The accuracy
        acc_test = calcAccuracy(cM_test);
        acc_train = calcAccuracy(cM_train);
        
        cv_acc_rates_test(test_index) = acc_test;
        cv_acc_rates_train(test_index) = acc_train;
    end

    mean_acc_test = mean(cv_acc_rates_test);
    mean_acc_train = mean(cv_acc_rates_train);
end
 