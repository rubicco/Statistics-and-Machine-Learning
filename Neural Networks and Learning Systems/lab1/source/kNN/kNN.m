function [ labelsOut ] = kNN(X, k, Xt, Lt)
    %KNN Your implementation of the kNN algorithm
    %   Inputs:
    %               X  - Features to be classified
    %               k  - Number of neighbors
    %               Xt - Training features
    %               LT - Correct labels of each feature vector [1 2 ...]'
    %
    %   Output:
    %               LabelsOut = Vector with the classified labels

    labelsOut  = zeros(size(X,2),1);
    classes = unique(Lt);
    numClasses = length(classes);

    % iterate for all input data
    % column wise, because the data that we have is 2x200 size
    for i = 1:size(X,2)
        distances = sqrt(sum((Xt - X(:,i)).^2, 1));
        [B, I] = sort(distances);
        sorted_labels = Lt(I);
        k_element = sorted_labels(1:k);
        counts = tabulate(k_element);
        [b,label_index] = max(counts(:,2));
        labelsOut(i) = classes(label_index);
    end
end

%kNN()