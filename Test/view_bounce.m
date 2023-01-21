function im_tr = view_bounce(image, transform, rect, type)    
    if strcmp(type, 'wall')
        % Setting the borders for where to crop the transformed image
        crop = [rect(1,1)-10 rect(3,1)+10; rect(1,2)-274-10 rect(3,2)+10];
        crop(1,:)
    else
        crop = [rect(1,1)-10 rect(3,1)+10; rect(1,2)-10 rect(3,2)+160+10];
        
    end
    [im_tr] = imtransform(image,transform, 'XData', crop(1,:), 'YData', crop(2,:));
    
end