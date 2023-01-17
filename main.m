a = 1;
v = VideoReader('squash_vid_10sek.mp4');
v.CurrentTime = 2.5;

currAxes = axes;
while hasFrame(v)
    vidFrame = readFrame(v);
    image(vidFrame, 'Parent', currAxes);
    currAxes.Visible = 'off';
    pause(1/v.FrameRate);
end

whos frame
