close all
clear
clc

%%

videoFReader = vision.VideoFileReader('GreenSharpie.wmv',...
    'VideoOutputDataType','double');

%videoFReader = vision.VideoFileReader('ten_sec.mp4',...
%    'VideoOutputDataType','double');

vidPlayer = vision.DeployableVideoPlayer;

%% Create tracker object

tracker = vision.HistogramBasedTracker;

%% Initialize tracker

%Could use "blob analysis"

img = step(videoFReader);
figure
imshow(img)
h = imrect;
wait(h);
boxLoc = getLoc(h)

imgYcbcr = rgb2ycbcr(img);
initializeObject(tracker, imgYcbcr(:,:,2),boxLoc);


%% Track object

idx = 1;
while (~isDone(videoFReader))

    img = step(videoFReader);
    imgYcbcr = rgb2ycbcr(img);
    [bbox,~,score(idx)] = step(tracker, img(:,:,1));

    if score(idx) > 0.5
        %Output tracking result
        out = insertShape(img, 'Rectangle',bbox);
    
    else
        %Find ball
        boxLoc = segmentBall(img, 5000);
        if ()
            %If ball is found, reinitialize and track again
        else
            %If ball not found, output unaltered frame
        end
    end

    step(vidPlayer, out);
    pause(0.1);
    idx = idx + 1;



end

figure;
plot(score);
xlabel('Frame #');
ylabel('Confidence Score (0,1)')