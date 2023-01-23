function im_tr = transform_bounce(image, transform, rect, type)
% Simple function to transform an image and cropping the resulting image to
% the dimensions of a squash court
% image: image to be transformed
% transform: the projective transform
% rect: the new coordinates of the points in the projected image
% type: either 'wall' or 'floor'

    if strcmp(type, 'wall')
        % Setting the cropping borders of the wall
        crop = [rect(2,1) rect(3,1); rect(2,2)-462 rect(2,2)];
    else
        % Setting the cropping borders of the floor
        crop = [rect(1,1) rect(4,1); rect(1,2) rect(2,2)+160];
        
    end
    [im_tr] = imtransform(image,transform, 'XData', crop(1,:), 'YData', crop(2,:));
    
end