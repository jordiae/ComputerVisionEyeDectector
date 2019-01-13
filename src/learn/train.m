seed = 1996;
rng(seed);
load('../../data/splittedDatasets.mat');
customFeatIndices = 1:nCustomFeatures;
HOGFeatIndices = (nCustomFeatures+1):(nCustomFeatures+nHOGfeatures);
allFeatIndices = 1:(nCustomFeatures+nHOGfeatures);
labelIndex = nCustomFeatures+nHOGfeatures+1;

disp('SVM 1');
% Detector ulls només HOG
SVMModelEyesHOG = fitcsvm(datasetEyesLearn(:,HOGFeatIndices),datasetEyesLearn(:,labelIndex),'ClassNames',[1,0],'OptimizeHyperparameters','auto');

disp('SVM 2');
% Detector ulls només característiques pròpies
SVMModelEyesCustom = fitcsvm(datasetEyesLearn(:,customFeatIndices),datasetEyesLearn(:,labelIndex),'ClassNames',[1,0],'OptimizeHyperparameters','auto');

disp('SVM 3');
% Detector ulls característiques pròpies i HOG
SVMModelEyesHOGCustom = fitcsvm(datasetEyesLearn(:,allFeatIndices),datasetEyesLearn(:,labelIndex),'ClassNames',[1,0],'OptimizeHyperparameters','auto');


disp('SVM 4');
% Detector mirada només HOG
SVMModelLookingHOG = fitcsvm(datasetLookingLearn(:,HOGFeatIndices),datasetLookingLearn(:,labelIndex),'ClassNames',[1,0],'OptimizeHyperparameters','auto');

disp('SVM 5');
% Detector mirada només caractzerístiques pròpies
SVMModelLookingCustom = fitcsvm(datasetLookingLearn(:,customFeatIndices),datasetLookingLearn(:,labelIndex),'ClassNames',[1,0],'OptimizeHyperparameters','auto');

disp('SVM 6');
% Detector mirada caractzerístiques pròpies i HOG
SVMModelLookingHOGCustom = fitcsvm(datasetLookingLearn(:,allFeatIndices),datasetLookingLearn(:,labelIndex),'ClassNames',[1,0],'OptimizeHyperparameters','auto');


save('../../models/models.mat','SVMModelEyesHOG','SVMModelEyesCustom','SVMModelEyesHOGCustom','SVMModelLookingHOG','SVMModelLookingCustom','SVMModelLookingHOGCustom');
