%%Clear all
close all
clear
clc

%% Reading the video
video = vision.VideoFileReader('CAM1.mov');
video_frames = read(VideoReader('CAM1.mov'));
player = vision.DeployableVideoPlayer('Location', [10,100]);

%%Detect the ball
fgDetector = vision.ForegroundDetector('NumTrainingFrames', 10, 'InitialVariance', 0.0015); %0.05
fgPlayer = vision.DeployableVideoPlayer('Location', player.Location + [500 120]);
blobAnalyzer = vision.BlobAnalysis('AreaOutputPort', true, 'MinimumBlobArea', 10, 'CentroidOutputPort', true);

frameNr = 1;
crop_x = 100;
crop_y = 10;
crop_width = 1000;
crop_height = 1000;
while ~isDone(video)
    
    im = step(video);
    image = imcrop(im,[crop_x, crop_y, crop_width, crop_height]);
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

%% Projectivity transform and determining if serve is valid

% Extracting the exact frame where the bounces happen and extracting the
% poisition of the ball in the images
bounce_wall_index = bouncePoints(1,3); 
bounce_floor_index = bouncePoints(2,3);
bounce_image_wall = video_frames(:,:,:,bounce_wall_index);
bounce_image_floor = video_frames(:,:,:,bounce_floor_index);
bounce_wall_pos = bouncePoints(1,1:2) + [crop_x, crop_y];
bounce_floor_pos = bouncePoints(2,1:2) + [crop_x, crop_y];

% Based on the fixed camera configuration, the points a,b,c,d,e,f,g,h
% Represent image coordinates of:

% Left end of service line
a = [115;420;1];
% Bottom left corner of the wall
b = [112;722;1];
% Bottom right corner of the wall
c = [1004;684;1];
% Right end of service line
d = [1004;466;1];
% Bottom left corner of the wall (same as b)
e = [112;722;1];
% Left end of short line
f = [50;910;1];
% Right end of short line
g = [1601;745;1];
% Bottom right corner of the wall (same as c)
h = [1004;684;1];

% The points above will, in the projected image, be mapped to these
% coordinates:
rect_wall = [0 -183;0 0;640 0;640 -183];
rect_floor = [0 0;0 549;640,549;640,0];

% Create a transform for wall and floor projections
tr_wall =  maketform('projective',[a(1:2)';b(1:2)';c(1:2)';d(1:2)'],rect_wall);
tr_floor = maketform('projective',[e(1:2)';f(1:2)';g(1:2)';h(1:2)'],rect_floor);

% Sending the ball-bounce contact points through the transformation as well
[x_wall, y_wall] = tformfwd(tr_wall,bounce_wall_pos(1),bounce_wall_pos(2));
[x_floor, y_floor] = tformfwd(tr_floor,bounce_floor_pos(1),bounce_floor_pos(2));

% Transforming and cropping the image
im_wall = view_bounce(bounce_image_wall, tr_wall, rect_wall, 'wall');
im_floor = view_bounce(bounce_image_floor, tr_floor, rect_floor, 'floor');



% For the image of the wall, we want to count distance from the bottom and
% up. Therefore, we get the total number of rows in the image
[rows_wall, ~, ~] = size(im_wall);

% determining if it is a valid serve or not
valid = check_if_valid(abs(y_wall),x_floor, y_floor, 3,4);
color = 'green';
if ~valid
    color = 'red';
end

bounce = figure;
subplot(121)

% Drawing circles resembling the ball
im_wall = insertShape(im_wall,"FilledCircle",[x_wall, rows_wall+y_wall 4], 'Color', color);
imshow(im_wall);
title('Wall Bounce');
subplot(122)
im_floor = insertShape(im_floor,"FilledCircle",[x_floor, y_floor 4], 'Color', color);
imshow(im_floor);
title('Floor Bounce')


%% Release reader and player object
release(video);

delete(player);
delete(fgPlayer);