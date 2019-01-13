seed = 1996;
rng(seed);
load('../../data/dataset.mat');
[datasetEyesLearn,datasetEyesTest] = splitLearnTest(datasetEyes);
[datasetLookingLearn,datasetLookingTest] = splitLearnTest(datasetLooking);
save('../../data/splittedDatasets.mat','datasetEyesLearn','datasetEyesTest','datasetLookingLearn','datasetLookingTest','nHOGfeatures','nCustomFeatures');