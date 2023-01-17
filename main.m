a = 1;
v = VideoReader('ten_sec.mp4');
v.CurrentTime = 2.5;

currAxes = axes;
while hasFrame(v)
    vidFrame = readFrame(v);
    image(vidFrame, 'Parent', currAxes);
    currAxes.Visible = 'off';
    pause(1/(0.05*v.FrameRate));
end

whos frame
