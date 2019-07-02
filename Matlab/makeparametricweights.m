if length(dir_param) > 1
    d_val = dir_param;
    m = mean(d_val);
    mult = sqrt(sum((d_val-m).^2));
    dreg = (d_val-m)./mult;
else
    dreg = 0;
end
dreg = dreg';

if length(coh_param) > 1
    c_val = coh_param;
    m = mean(c_val);
    mult = sqrt(sum((c_val-m).^2));
    creg = (c_val-m)./mult;
else
    creg = 0;
end
creg = creg';

if exist('rt_param','var')
    rt_val = rt_param;
    m = mean(rt_val);
    mult = sqrt(sum((rt_val-m).^2));
    rtreg = (rt_val-m)./mult;
end

% c_val2 = [0 12 25 100]';
% l = 1;
% m = mean(c_val2(:,l));
% mult = sqrt(sum((c_val2(:,l)-m).^2));
% creg(:,l) = (c_val2(:,l)-m)./mult;