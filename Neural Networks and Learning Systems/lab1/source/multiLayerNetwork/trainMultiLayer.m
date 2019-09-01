function [Wout,Vout, trainingError, testError ] = trainMultiLayer(Xtraining,Dtraining,Xtest,Dtest, W0, V0,numIterations, learningRate )
%TRAINMULTILAYER Trains the network (Learning)
%   Inputs:
%               X* - Trainin/test features (matrix)
%               D* - Training/test desired output of net (matrix)
%               V0 - Weights of the output neurons (matrix)
%               W0 - Weights of the output neurons (matrix)
%               numIterations - Number of learning setps (scalar)
%               learningRate - The learningrate (scalar)
%
%   Output:
%               Wout - Weights after training (matrix)
%               Vout - Weights after training (matrix)
%               trainingError - The training error for each iteration
%                               (vector)
%               testError - The test error for each iteration
%                               (vector)

% Initiate variables
trainingError = nan(numIterations+1,1);
testError = nan(numIterations+1,1);
numTraining = size(Xtraining,2);
numTest = size(Xtest,2);
numClasses = size(Dtraining,1) - 1;
Wout = W0;
Vout = V0;
N = size(Xtraining,2);

% Calculate initial error
Ytraining = runMultiLayer(Xtraining, W0, V0);
Ytest = runMultiLayer(Xtest, W0, V0);
trainingError(1) = sum(sum((Ytraining - Dtraining).^2))/(numTraining*numClasses);
testError(1) = sum(sum((Ytest - Dtest).^2))/(numTest*numClasses);

for n = 1:numIterations
    [Ytraining, L, U] = runMultiLayer(Xtraining, Wout, Vout);
    
    %S_unbised = Wout(:,2:size(Wout,2))*Xtraining(2:size(Xtraining,1),:); %Calculate the sumation of the weights and the input signals (hidden neuron)
    %U_unbised = tanh(S_unbised); %Calculate the activation function as a hyperbolic tangent
   
    %S_biased = Wout * Xtraining;
    %U_biased = tanh(S_biased);
    %U_biased = [ones(1,size(U_biased,2)); U_biased];
    
    U_unbiased = U(2:size(U, 1),:);
    
    grad_v = 2*((Ytraining-Dtraining)*U')/N; %Calculate the gradient for the output layer
    
    der_sigma = 1 - U_unbiased.^2;
    grad_w = 2*((Vout(:,2:size(Vout,2))'*(Ytraining-Dtraining).*der_sigma)*Xtraining')/N; %..and for the hidden layer.



    Wout = Wout - learningRate * grad_w; %Take the learning step.
    Vout = Vout - learningRate * grad_v; %Take the learning step.

    Ytraining = runMultiLayer(Xtraining, Wout, Vout);
    Ytest = runMultiLayer(Xtest, Wout, Vout);

    trainingError(1+n) = sum(sum((Ytraining - Dtraining).^2))/(numTraining*numClasses);
    testError(1+n) = sum(sum((Ytest - Dtest).^2))/(numTest*numClasses);
end

end
