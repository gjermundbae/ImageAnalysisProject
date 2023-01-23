function [p1,p2,p3,p4] = get_points(im, type)
% NOT used in the final delivery
% Function for manually marking points in an image. The function is used
% when the camera setup is not fixed.
%
% im: image to mark points on
% type: either 'wall' or 'floor'

    figure;
    hold on;
    
    %Display example pictures of where to mark new points
    if strcmp(type, 'wall')
        
        imshow('ex_wall.jpg')
    else
        
        imshow('ex_floor.jpg')
    end
    title('Click on the corners in order and press enter')
    bounce = figure;
    imshow(im);
    title(type);
    [x, y]=getpts(bounce);
    

    plot(x,y,'or','MarkerSize',12);

    FNT_SZ = 25;
    % take the points in homogenous coordinates

    p1=[x(1) y(1) 1]';
    text(p1(1), p1(2), 'a', 'FontSize', FNT_SZ, 'Color', 'w')
    p2=[x(2) y(2) 1]';
    text(p2(1), p2(2), 'b', 'FontSize', FNT_SZ, 'Color', 'w')
    p3=[x(3) y(3) 1]';
    text(p3(1), p3(2), 'c', 'FontSize', FNT_SZ, 'Color', 'w')
    p4=[x(4) y(4) 1]';
    text(p4(1), p4(2), 'd', 'FontSize', FNT_SZ, 'Color', 'w')
    close
end