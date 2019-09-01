function [ acc ] = calcAccuracy( cM )
    %CALCACCURACY Takes a confusion matrix amd calculates the accuracy

    acc = sum(diag(cM)) / sum(cM,'all'); % Replace with your own code

end

