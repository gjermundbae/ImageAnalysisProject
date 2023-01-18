
% import the video file
obj = VideoReader('squash_videos\short_seq1_60fps.MOV');
vid = read(obj);
  
 % read the total number of frames
frames = obj.NumFrames;
  
% file format of the frames to be saved in
ST ='.jpg';
  
% reading and writing the frames 
for x = 1 : frames
  
    % converting integer to string
    Sx = num2str(x);
  
    % concatenating 2 strings
    Strc = strcat(Sx, ST);
    Vid = vid(:, :, :, x);
    cd frames2
  
    % exporting the frames
    imwrite(Vid, Strc);
    cd ..  
end