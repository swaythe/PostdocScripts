hue = 200;
showFix([hue hue hue 0]);

%% Dim fixation cross for 0.5 s
dimTime = 2.5;
dim = 1;
tic;
while dim
    dimInt = toc;
    hue = hue - 1;
    showFix([hue hue hue 0]);
    if dimInt >= dimTime
        dim = 0;
        continue;
    end
end