%% Foreground detector

videoSource = VideoReader('squash_videos\short_seq1_60fps.MOV');

detector = vision.ForegroundDetector( ...
    'NumTrainingFrames', 5, ...
    'InitialVariance', 30*30);



% Convert RGB image to chosen color space
I = rgb2hsv(img);

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

%% Remove disturbances
%Create structural element
diskElem = strel('disk',1);
Ibwopen = imopen(BW,diskElem);

%% Blob analysis


blob = vision.BlobAnalysis( 'CentroidOutputPort', false, 'AreaOutputPort', false, ...
       'BoundingBoxOutputPort', true, ...
       'MinimumBlobAreaSource', 'Property','MinimumBlobArea',7,...
    'MaximumBlobArea',18); 
%[objArea, objCentroid, bboxOut] = step(hBlobAnalysis, Ibwopen);

shapeInserter = vision.ShapeInserter('BorderColor','White');


%% play results
videoPlayer = vision.VideoPlayer();
while hasFrame(videoSource)
     frame  = readFrame(videoSource);
     fgMask = detector(frame);
     bbox   = blob(fgMask);
     out    = shapeInserter(frame,bbox);
     videoPlayer(out);
     pause(0.1);
end

%% Release
release(videoPlayer);
release(vidReader);