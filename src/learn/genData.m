seed = 1996;
rng(seed);
PATH = '../../data/'; % 'I:/vc/Short Project/
[lx,ly,rx,ry,Inames,looking] = scanFiles(PATH);
size_rectangle_escalat_x = 128;
size_rectangle_escalat_y = 32;


K = zeros(size_rectangle_escalat_y,size_rectangle_escalat_x);
ratioExamplesNOEyeToEye = 95/5;
[~,nHOGfeatures] = size(extractHOGFeatures(K));
hogfeateyes =  zeros(length(lx),nHOGfeatures);
hogfeatNOeyes = zeros(ratioExamplesNOEyeToEye*length(lx),nHOGfeatures);

[~,nCustomFeatures] = size(extractLBPFeatures(K));
customFeatEyes = zeros(length(lx),nCustomFeatures);
customFeatNOEyes = zeros(ratioExamplesNOEyeToEye*length(lx),nCustomFeatures);

for i = 1:length(lx)
    I = imread(char(Inames(i)));
    matriuPuntsUlls = [lx(i),ly(i);rx(i),ry(i)];
    distanciaEntreUlls = pdist(matriuPuntsUlls,'euclidean');
    d = distanciaEntreUlls;
    %imshow(I);
    %rectangle('Position',[uint8(rx(1) - d*0.35), uint8(ry(1) -  d*0.3), uint8(d + d*0.75),	 uint8(d*0.5)],'EdgeColor','green');
    %features = extractHOGFeatures(imread(char(Inames(1))));

    %[lx,ly,rx,ry,Inames] = myscanfiles();
    %I = imread(char(Inames(573)));
    %matriuPuntsUlls = [lx(573),ly(573);rx(573),ry(573)];
    %distanciaEntreUlls = pdist(matriuPuntsUlls,'euclidean');
    %d = distanciaEntreUlls;
    %imshow(I);
    %r = rectangle('Position',[uint8(rx(573) - d*0.35), uint8(ry(573) -  d*0.3), uint8(d + d*0.75),	 uint8(d*0.5)],'EdgeColor','green');
    %features = extractHOGFeatures(imread(char(Inames(1))));
    %subim = image(x_min:x_max,y_min:y_max,:);
    rect = [uint8(rx(i) - d*0.35), uint8(ry(i) -  d*0.3), uint8(d + d*0.75),	 uint8(d*0.5)];
    J = imcrop(I,rect);
    J = imfilter(J,fspecial('gaussian'));
    J = imresize(J,[size_rectangle_escalat_y size_rectangle_escalat_x]);
    hogfeateyes(i,:) = extractHOGFeatures(J);
    customFeatEyes(i,:) = extractLBPFeatures(J);%table2array(normalize(obtenirCaracteristiques(J)));
    %figure;imshow(J);
    for j = 1:ratioExamplesNOEyeToEye
        [f,c] = size(I);
        
        xNOeye = randi(c-size_rectangle_escalat_x+1)+(0:size_rectangle_escalat_x-1);
        yNOeye = randi(f-size_rectangle_escalat_y+1)+(0:size_rectangle_escalat_y-1);
        while ~((((xNOeye(1) + size_rectangle_escalat_x) < rect(1)) | (xNOeye(size_rectangle_escalat_x)-size_rectangle_escalat_x) > (rect(1) + rect(3))) & (((yNOeye+size_rectangle_escalat_y) < rect(2)) | (yNOeye-size_rectangle_escalat_y) > (rect(2) + rect(4))))
            xNOeye = randi(c-size_rectangle_escalat_x+1)+(0:size_rectangle_escalat_x-1);
            yNOeye = randi(f-size_rectangle_escalat_y+1)+(0:size_rectangle_escalat_y-1);
        end
        imNOeye = I(yNOeye,xNOeye);
        %figure;imshow(imNOeye);
        %pause;
        %imshow(J);
        %figure;imshow(imNOeye);
        %pause();
        
        hogfeatNOeyes(i+j-1,:) = extractHOGFeatures(imNOeye);
        customFeatNOEyes(i+j-1,:) = extractLBPFeatures(imNOeye);%table2array(normalize(obtenirCaracteristiques(imNOeye)));
    end
end


yy = zeros(30420,1); yy(1:1521) = ones(1521,1);
datasetEyes = [customFeatEyes hogfeateyes; customFeatNOEyes hogfeatNOeyes];
datasetEyes = [datasetEyes yy];


X = [customFeatEyes hogfeateyes];
datasetLooking = [customFeatEyes hogfeateyes];
datasetLooking = [datasetLooking looking];
save('../../data/dataset.mat','datasetEyes','datasetLooking','nHOGfeatures','nCustomFeatures');

