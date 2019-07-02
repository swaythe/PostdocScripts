function Out = checkDotPos(dotPos, dn)

Out = 0;

Grid = zeros(4);
frn = 0.25:0.25:1;

for dIdx = 1:dn*3
    for di = 1:4
        for dj = 1:4
            if di==1 && dj==1
                if dotPos(dIdx,1) <= frn(di) && dotPos(dIdx,2) <= frn(dj)
                    Grid(di,dj) = Grid(di,dj) + 1;
                end
            elseif di==1
                if dotPos(dIdx,1) <= frn(di) && ...
                        dotPos(dIdx,2) > frn(dj-1) && dotPos(dIdx,2) <= frn(dj)
                    Grid(di,dj) = Grid(di,dj) + 1;
                end
            elseif dj==1
                if dotPos(dIdx,1) > frn(di-1) && dotPos(dIdx,1) <= frn(di) && ...
                        dotPos(dIdx,2) <= frn(dj)
                    Grid(di,dj) = Grid(di,dj) + 1;
                end
            else
                if dotPos(dIdx,1) > frn(di-1) && dotPos(dIdx,1) <= frn(di) && ...
                        dotPos(dIdx,2) > frn(dj-1) && dotPos(dIdx,2) <= frn(dj)
                    Grid(di,dj) = Grid(di,dj) + 1;
                end
            end
        end
    end
end

for di = 1:4
    for dj = 1:4
        if Grid(di,dj) > ceil((dn*3/16)+(dn*3/16)/3)...
                || Grid(di,dj) < ceil((dn*3/16)-(dn*3/16)/3)
            Out = Out + 1;
        end
    end
end

