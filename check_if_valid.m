function valid = check_if_valid(y_wall,x_floor, y_floor, wall_radius, floor_radius) 
    y_wall
    valid = 1;
    if y_floor<549+floor_radius || y_wall<183+wall_radius || x_floor>317-floor_radius
        valid = 0;
end