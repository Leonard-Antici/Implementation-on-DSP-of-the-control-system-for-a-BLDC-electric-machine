function dir = fcn(u)

persistent dir_prev;
if isempty(dir_prev)
    dir_prev=0;
end
if (u < -2 || u > 2)
    dir=dir_prev;
else
    if u > 0.5
        dir = 1;
    elseif u < -0.5
        dir = -1;
    else
        dir = 0;
    end
end
dir_prev=dir;