function [confMat, accuracy, FScoreMinority] = metrics(truth,predicted)
    confMat = confusionmat(truth,predicted);
    accuracy = sum(diag(confMat))/(sum(sum(confMat)));
    TPMin = confMat(2,2);
    FPMin = sum(confMat(:,2))-TPMin;
    FNMin = sum(confMat(2,:))-TPMin;
    FScoreMinority = 2*TPMin/(2*TPMin + FPMin + FNMin);
end