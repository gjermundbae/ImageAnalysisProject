function [tr] = make_transform(p1,p2,p3,p4, rect)
    rect_floor = [0 0;0 549;640,549;640,0];
    
    rect_wall = [0 0;640 0;640,-183;0,-183];

    % TRANSFORM TO WALL
    tr = maketform('projective',[p1(1:2)';p2(1:2)';p3(1:2)';p4(1:2)'],rect);
end