%%Clear all
close all
clear
clc

%% Reading the video
video = vision.VideoFileReader('CAM1.mov');
player = vision.DeployableVideoPlayer('Location', [10,100]);

%%Detect the ball
fgDetector = vision.ForegroundDetector('NumTrainingFrames', 10, 'InitialVariance', 0.0015); %0.05
fgPlayer = vision.DeployableVideoPlayer('Location', player.Location + [500 120]);
blobAnalyzer = vision.BlobAnalysis('AreaOutputPort', true, 'MinimumBlobArea', 10, 'CentroidOutputPort', true);

frameNr = 1;

while ~isDone(video)
    
    im = step(video);
    image = imcrop(im,[100,10,1000,1000]);
    %image = step(video);
    I = rgb2gray(image);
    %detect ball
    fgMask = step(fgDetector,I);
    fgMask = bwareaopen(fgMask,25); %removes small objects from binary image, e.g. noise in background
    [~, detection] = step(blobAnalyzer,fgMask);
    step(fgPlayer,fgMask);

    if ~isempty(detection)
        position = detection(1,:);
        pos(frameNr,:) = detection(1,:);
        position(:,3) = 10;
        combinedImage = insertShape(image,'circle',position); %,'Ball'
        step(player,combinedImage);
        
    else
        step(player, image);
        pos(frameNr,:) = [NaN NaN];
    end
    step(fgPlayer,fgMask);
    
    step(player,image);
    
    frameNr = frameNr + 1;
end

%% Visualize the trajectory
figure, imshow(image)
hold on
plot(pos(:,1),pos(:,2),'b-o','LineWidth',2)

%% Release reader and player object
release(video);

delete(player);
delete(fgPlayer);