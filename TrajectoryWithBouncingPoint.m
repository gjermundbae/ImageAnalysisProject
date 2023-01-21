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
plot(pos(:,1),pos(:,2),'r-o','LineWidth',2)

%% Bouncing
%Visualize the altitude and longitude
arrX = pos(:,1);
arrY = pos(:,2);
figure
hold on
plot((1:size(pos,1)),arrY,'r-o','LineWidth',2)
plot((1:size(pos,1)),arrX,'r-o','LineWidth',2)

% Find change of direction -> Ball bouncing
bouncePoints = [];
for index = 2:(size(pos,1)-2)
    diffDirX1 = (arrX(index,:))- (arrX(index-1,:));
    diffDirY1 = (arrY(index,:))- (arrY(index-1,:));
    diffDirX2 = (arrX(index+1,:))- (arrX(index,:));
    diffDirY2 = (arrY(index+1,:))- (arrY(index,:));
    if diffDirX1*diffDirX2 < 0
        bouncePoints = [bouncePoints; [arrX(index,:), arrY(index,:),index]];
    elseif diffDirY1*diffDirY2 < -250                                           %Kommenter ut disse linjene hvis du bare vil ha med spretten i veggen
        bouncePoints = [bouncePoints; [arrX(index,:), arrY(index,:),index]];    %Kommenter ut disse linjene hvis du bare vil ha med spretten i veggen
    end
end

%% new plot
figure, imshow(image)
hold on
plot(pos(:,1),pos(:,2),'r-o','LineWidth',2)
plot(bouncePoints(:,1),bouncePoints(:,2),'xr','LineWidth',7, 'Color', 'b')

%% Release reader and player object
release(video);

delete(player);
delete(fgPlayer);