%%
close all
clear
clc
%% Noen greier
vid = VideoReader('usable_2.MOV');
allframes = read(vid);
im = allframes(:,:,:,5);

%% Get points then project wall and floor in the moment of bounce
close all
bounce_wall_index = 1; %get_bounce_wall_index(allframes); Need function from Simen
bounce_floor_index = 1;%get_bounce_floor_index(allframes); Need function from Simen
test_ind = 100;
bounce_image_wall = allframes(:,:,:,test_ind);
bounce_image_floor = allframes(:,:,:,test_ind);

[a,b,c,d] = get_points(bounce_image_wall, 'wall');
[e,f,g,h] = get_points(bounce_image_floor, 'floor');

rect_wall = [0 0;0 457;640 457;640 0];
rect_floor = [0 0;0 549;640,549;640,0];

tr_wall = make_transform(a,b,c,d, rect_wall);
tr_floor = make_transform(e,f,g,h, rect_floor);

im_wall = view_bounce(bounce_image_wall, tr_wall, rect_wall, 'wall');
im_floor = view_bounce(bounce_image_floor, tr_floor, rect_floor, 'floor');

figure, imshow(im_wall);
figure, imshow(im_floor);


