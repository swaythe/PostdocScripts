function d = massageDir(dirn)

    d = dirn;
    if d > 360
        d = d - 360;
    elseif d < 0
        d = 360 + d;
    end
    
return
