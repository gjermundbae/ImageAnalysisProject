function valid = check_if_valid(y_wall,x_floor, y_floor, wall_radius, floor_radius) 
% Simple function to check the validity of a serve
% The ball needs to be over the service line, over the short line and to
% the left of the half court line
%
% y_wall: height of the contact point with the wall
% x_floor: position in x direction of the contact point with the floor
% y_floor: position in y direction of the contact point with the floor
% wall_radius: approximate estimate of the radius of a ball at the wall
% floor_radius: approximate estimate of the radius of a ball at the floor

    valid = 1;
    if y_floor<549+floor_radius || y_wall<183+wall_radius || x_floor>317-floor_radius
        valid = 0;
    end
end