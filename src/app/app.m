%load('../../models/bestModel.mat');
load('../../data/dataset.mat');
load('../../models/models.mat');
load('../../data/splittedDatasets.mat');
%I = imread('../data/BioID_0000.pgm');
I = rgb2gray(imread('../../tests/trump.jpeg'));
%I = rgb2gray(imread('../../tests/messi.jpg'));
customFeatIndices = 1:nCustomFeatures;
HOGFeatIndices = (nCustomFeatures+1):(nCustomFeatures+nHOGfeatures);
allFeatIndices = 1:(nCustomFeatures+nHOGfeatures);
labelIndex = nCustomFeatures+nHOGfeatures+1;

% Detector ulls només HOG
%predWin = @(block_struct) predict(SVMModelEyesHOG,extractHOGFeatures(block_struct.data(:)));
%B = blockproc(I,[3 3],predWin);
%fun = @(x) sum( x(:) );
%fun = @(x) predict(SVMModelEyesHOG,extractHOGFeatures(x(:)));
%m = 128;
%n = 32;
%w = [m n];
%B = nlfilter( I, w, fun );

%yhat = predict(SVMModelEyesHOG,extractHOGFeatures(I(1:128,1:32)));

SVMModelEyeHOGFinal = fitcsvm(datasetEyesLearn(:,HOGFeatIndices),datasetEyesLearn(:,labelIndex),'ClassNames',[1,0]);
SVMModelLookingHOGFinal = fitcsvm(datasetLookingLearn(:,HOGFeatIndices),datasetLookingLearn(:,labelIndex),'ClassNames',[1,0],'BoxConstraint', 0.4535 ); % 0.37611 

image_resized_x = 128;
image_resized_y = 32;
k = 1; % trump: 1. obama: 0.5. obamaBig: 4
window_x = image_resized_x*k;
window_y = image_resized_y*k;
step_x = 1;%10;
step_y = 1;%10;
[R C] = size(I);
eye = false;
eyeSubImage = zeros(window_x,window_y);
yhatMax = zeros(R,C);
yhat = zeros(R,C);
earlyStop = false;
for i = 1:step_y:(R-window_y)
    for j = 1:step_x:(C-window_x)
        hogs = extractHOGFeatures(imresize(imfilter(I(i:i+window_y,j:j+window_x),fspecial('gaussian')),[image_resized_y,image_resized_x]));
        %lbps = extractLBPFeatures(imresize(imfilter(I(i:i+window_y,j:j+window_x),fspecial('gaussian')),[image_resized_y,image_resized_x]));
        % yhat(i,j) = predict(SVMModelEyeHOGFinal,hogs);
        %yhat(i,j) = predict(SVMModelEyesCustom,lbps);
        if ~earlyStop
            %[label,score,cost] = predict(SVMModelEyesHOG,hogs);
            [label,score,cost] = predict(SVMModelEyeHOGFinal, hogs);
            %[label,score,cost] = predict(SVMModelEyesCustom,lbps);
            yhatMax(i,j) = label*score(1);
            if label == 1
                eye = true;
            end
        end
        if earlyStop && sum(sum(yhat)) > 0
            yhat(i,j) = predict(SVMModelEyeHOGFinal,hogs);
            break
        end
    end
    if earlyStop && sum(sum(yhat)) > 0
        eye = true;
        eyeSubImage = I(i:i+window_y,j:j+window_x);
        break
    end
end

if earlyStop
    imshow(eyeSubImage);
    hogs =  extractHOGFeatures(imresize(imfilter(eyeSubImage,fspecial('gaussian')),[image_resized_y,image_resized_x]));
    lbps = extractLBPFeatures(imresize(imfilter(eyeSubImage,fspecial('gaussian')),[image_resized_y,image_resized_x]));
    
    if eye == 1
        disp('EYES: yes');
        %yhatLooking = predict(bestModelLooking,hogs);
        yhatLooking = predict(SVMModelLookingCustomHOGFinal,[lbps hpgs]);
        if yhatLooking == 1
            disp('LOOKING: yes');
        else
            disp('LOOKING: no');
        end
    else
         disp('EYES: no');
    end
else
    if eye == 1
        %[maxVal,psX] = max(yhatMax);
        [maxVal,~] = max(max(yhatMax));
        [psY,psX]=find(yhatMax==maxVal);
        %imshow(I(psY:psY+window_y,psX:psX+window_x));
        imshow(I);
        hold on;
        rectangle('Position',[psX,psY,window_x,window_y],'EdgeColor', 'r','LineWidth', 3);
        disp('EYES: yes');
        hogs = extractHOGFeatures(imresize(imfilter(I(psY:psY+window_y,psX:psX+window_x),fspecial('gaussian')),[image_resized_y,image_resized_x]));
        lbps =  extractLBPFeatures(imresize(imfilter(I(psY:psY+window_y,psX:psX+window_x),fspecial('gaussian')),[image_resized_y,image_resized_x]));
        %yhatLooking = predict(bestModelLooking,hogs);
        yhatLooking = predict(SVMModelLookingHOGFinal,hogs);
        if yhatLooking == 1
            disp('LOOKING: yes');
        else
            disp('LOOKING: no');
        end
    else
         disp('EYES: no');
    end

    
end
