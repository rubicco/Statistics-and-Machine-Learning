function [ cM ] = calcConfusionMatrix( Lclass, Ltrue )
    classes = unique(Ltrue);
    numClasses = length(classes);
    cM = zeros(numClasses);

    for i = 1:size(Ltrue,1)
        x = Lclass(i);
        y = Ltrue(i);
        cM(x,y) = cM(x,y) + 1;
    end
    cM;
end

