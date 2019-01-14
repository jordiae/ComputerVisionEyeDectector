I = rgb2gray(imread('../../tests/trump.jpeg'));
imshow(I);
load('../../models/models.mat');
load('../../data/dataset.mat');
load('../../data/splittedDatasets.mat');
customFeatIndices = 1:nCustomFeatures;
HOGFeatIndices = (nCustomFeatures+1):(nCustomFeatures+nHOGfeatures);
allFeatIndices = 1:(nCustomFeatures+nHOGfeatures);
labelIndex = nCustomFeatures+nHOGfeatures+1;
size_rectangle_escalat_x = 128;
size_rectangle_escalat_y = 32;

SVMModelEyeHOGFinal = fitcsvm(datasetEyesLearn(:,HOGFeatIndices),datasetEyesLearn(:,labelIndex),'ClassNames',[1,0]);
SVMModelLookingHOGFinal = fitcsvm(datasetLookingLearn(:,HOGFeatIndices),datasetLookingLearn(:,labelIndex),'ClassNames',[1,0],'BoxConstraint', 0.4535 ); %0.37611 

while true
    imshow(I);
    rect = getrect();
    J = imcrop(I,rect);
    J = imfilter(J,fspecial('gaussian'));
    J = imresize(J,[size_rectangle_escalat_y size_rectangle_escalat_x]);
    imshow(J);
    [label,score,cost] = predict(SVMModelEyesHOG,extractHOGFeatures(J));
    p = predict(SVMModelEyesHOG,extractHOGFeatures(J));
    if p == 1
        disp('EYES: yes');
        pl = predict(SVMModelLookingHOG,extractHOGFeatures(J));
        if pl == 1
            disp('LOOKING: yes');
        else
            disp('LOOKING: no');
        end
    else
         disp('EYES: no');
    end
end