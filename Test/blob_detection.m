%% Load sample frames

%load sampleFrames.mat
subplot(1,4,1)
%img = imread('frames2\142.jpg');
img = imread('frames2\77.jpg');
imshow(img)
size(img)

%% Threshold image

% Convert RGB image to chosen color space
I = rgb2hsv(img);
I_2 = rgb2gray(img);

% Define thresholds for channel 1 based on histogram settings
channel1Min = 0.000;
channel1Max = 1.000;

% Define thresholds for channel 2 based on histogram settings
channel2Min = 0.000;
channel2Max = 1.000;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 0.000;
channel3Max = 0.164;

% Create mask based on chosen histogram thresholds
sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
BW = sliderBW;

subplot(1,4,2)
imshow(BW);

subplot(1,4,3)
imshow(I_2);

%% Remove disturbances
%Create structural element
diskElem = strel('disk',1);
Ibwclose = imclose(BW,diskElem);
Ibwopen = imopen(BW,diskElem);
%subplot(1,4,3)
%imshow(Ibwopen);
subplot(1,4,4)
imshow(Ibwclose);
%% Blob analysis


hBlobAnalysis = vision.BlobAnalysis('MinimumBlobArea',8,...
    'MaximumBlobArea',10); %
[objArea, objCentroid, bboxOut] = step(hBlobAnalysis, Ibwopen);

%% Annotate image




Ishape = insertShape(img, 'rectangle',bboxOut,'LineWidth',2);
figure
subplot(1,2,1)
imshow(Ishape);

numObj = numel(objArea);
%hTextIns = insertText('%d', 'Location',[20,20],'Color',...
%    [255 255 0], 'FontSize', 30);
Itext = insertText(Ishape, [20,20], int32(numObj),'FontSize', 40);

subplot(1,2,2)
imshow(Itext);

%% Clean up

release(hBlobAnalysis)


