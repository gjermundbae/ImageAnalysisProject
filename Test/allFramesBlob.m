%% Loop

%% Setup
% Create object to read video frames from the video file


vidReader = vision.VideoFileReader('squash_videos\short_seq1_60fps.MOV');
vidReader.VideoOutputDataType = 'double';

%Create structural element for morphological operations to remove
%disturbances
diskElem = strel('disk',1);

hBlobAnalysis = vision.BlobAnalysis('MinimumBlobArea',7,...
    'MaximumBlobArea',15); %



% Create VideoPlayer
vidPlayer = vision.DeployableVideoPlayer;

%% Alg in loop
while ~isDone(vidReader)

    %Read Frame
    vidFrame = step(vidReader);

    %Convert RGB image to chosen color space
    Ihsv = rgb2hsv(vidFrame);

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
    Ibw = (Ihsv(:,:,1) >= channel1Min ) & (Ihsv(:,:,1) <= channel1Max) & ...
        (Ihsv(:,:,2) >= channel2Min ) & (Ihsv(:,:,2) <= channel2Max) & ...
        (Ihsv(:,:,3) >= channel3Min ) & (Ihsv(:,:,3) <= channel3Max);
    %BW = sliderBW;


    % Use morphological operations to remove disturbances
    Ibwopen = imopen(Ibw, diskElem);

    % Extract blobs from the frame
    [objArea, objCentroid, bboxOut] = step(hBlobAnalysis, Ibwopen);

    % Insert a string of number of objects detected in the video frame
    numObj = length(objArea);

    % Draw box around detected objects and insert text
    Ishape = insertShape(vidFrame, 'rectangle',bboxOut,'LineWidth',2);
    Ishape_text = insertText(Ishape, [20,20], int32(numObj),'FontSize', 40);

    step(vidPlayer, Ishape_text);

end

%% Cleanup
release(vidReader)
release(hBlobAnalysis)
release(vidPlayer)