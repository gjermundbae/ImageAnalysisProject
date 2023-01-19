% The foreground detector requires a certain number of video frames in order 
% to initialize the Gaussian mixture model. This example uses the first 50 frames 
% to initialize three Gaussian modes in the mixture model.

foregroundDetector = vision.ForegroundDetector('NumGaussians', 3, ...
    'NumTrainingFrames', 500);

videoReader = VideoReader('squash_videos\short_seq1_60fps.MOV');

for i = 1:500
    frame = readFrame(videoReader); % read the next video frame
    foreground = step(foregroundDetector, frame);
end
%% 
% After the training, the detector begins to output more reliable segmentation 
% results. The two figures below show one of the video frames and the foreground 
% mask computed by the detector.
%%
figure; imshow(frame); title('Video Frame');
%%
figure; imshow(foreground); title('Foreground');

%% Background extracting
%background = imopen(frame,strel('disk',50));
%J = imsubtract(frame,background);
%figure; imshow(J); title('Subtracted background');

%% Step 2 - Detect Cars in an Initial Video Frame
% The foreground segmentation process is not perfect and often includes undesirable 
% noise. The example uses morphological opening to remove the noise and to fill 
% gaps in the detected objects.
%%
se = strel('disk', 3);
filteredForeground = imopen(foreground, se);
figure; imshow(filteredForeground); title('Clean Foreground');
%% 
% Next, find bounding boxes of each connected component corresponding 
% to a moving car by using vision.BlobAnalysis object. The object further filters 
% the detected foreground by rejecting blobs which contain fewer than 150 pixels.
%%
blobAnalysis = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
    'AreaOutputPort', false, 'CentroidOutputPort', false, ...
    'MinimumBlobArea',6, 'MaximumBlobArea',55);

bbox = step(blobAnalysis, filteredForeground);
%% 
% To highlight the detected cars, we draw green boxes around them.
%%
result = insertShape(frame, 'Rectangle', bbox, 'Color', 'green');
%% 
% The number of bounding boxes corresponds to the number of cars found in 
% the video frame. Display the number of found cars in the upper left corner 
% of the processed video frame.
%%
numCars = size(bbox, 1);
result = insertText(result, [10 10], numCars, 'BoxOpacity', 1, ...
    'FontSize', 14);
figure; imshow(result); title('Detected Cars');


%% Step 3 - Process the Rest of Video Frames
% In the final step, we process the remaining video frames.
%%
videoPlayer = vision.VideoPlayer('Name', 'Detected Cars');
videoPlayer.Position(3:4) = [650,400];  % window size: [width, height]
videoPlayer2 = vision.VideoPlayer('Name', 'Clean foreground');
videoPlayer2.Position(3:4) = [650,400];  % window size: [width, height]
se = strel('disk', 3); % morphological filter for noise removal

while hasFrame(videoReader)
    
    frame = readFrame(videoReader); % read the next video frame
    
    % Detect the foreground in the current video frame
    foreground = step(foregroundDetector, frame);
    
    % Use morphological opening to remove noise in the foreground
    filteredForeground = imopen(foreground, se);
    
    % Detect the connected components with the specified minimum area, and
    % compute their bounding boxes
    bbox = step(blobAnalysis, filteredForeground);

    % Draw bounding boxes around the detected cars
    result = insertShape(frame, 'Rectangle', bbox, 'Color', 'green');

    % Display the number of cars found in the video frame
    numCars = size(bbox, 1);
    result = insertText(result, [10 10], numCars, 'BoxOpacity', 1, ...
        'FontSize', 14);

    step(videoPlayer, result);  % display the results
    step(videoPlayer2, filteredForeground);
end


