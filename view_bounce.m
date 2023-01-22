function im_tr = view_bounce(image, transform, rect, type)    
    if strcmp(type, 'wall')
        % Setting the borders for where to crop the transformed image
        crop = [rect(2,1) rect(3,1); rect(2,2)-462 rect(2,2)];
    else
        crop = [rect(1,1) rect(4,1); rect(1,2) rect(2,2)+160];
        
    end
    [im_tr] = imtransform(image,transform, 'XData', crop(1,:), 'YData', crop(2,:));
    
end