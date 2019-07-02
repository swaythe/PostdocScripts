%% Some screen parameters
ImageMode = 0;
ScreenNumbers = Screen('Screens',1);
CurScreen = ScreenNumbers(1);
BGColor = 0;

AssertOpenGL
HideCursor
KillUpdateProcess;

Screen('Preference', 'VisualDebugLevel', 2);
Screen('Preference', 'SkipSyncTests', 0)

%% Determine current window and screen size in pixel coordinates
% [CurWindow, SR] = Screen('OpenWindow', 0, BGColor, [150,150,1200,700], 32, 2, 0, [], ImageMode); % Remove the rect definition for the actual exp
[CurWindow, SR] = Screen('OpenWindow', 0, BGColor, [], 32, 2, 0, [], ImageMode); 
[pixX, pixY] = Screen('WindowSize', CurWindow); % This value is in pixels
Center = [pixX pixY]/2;
[mmX, mmY] = Screen('DisplaySize', CurWindow); % This value is in mm
cmX = mmX/10; % We need width in cm because we are specifying viewing distance in cm

%% Dot parameters - basic
ViewDist = 50; % cm
DotDensity = 16.7; % dots/deg^2
DotSpeed = 6;
ApDiam = 9; % deg? Aperture "diameter" is a little confusing since the aperture is square to start with
DotSize = 3;
DotColor = [200, 200, 200];
MonRefresh = 60;

%% Dot parameters - calculated
% See how many dots appear on screen if the division by MonRefresh is taken away
DotNum =  ceil(DotDensity * ApDiam ^ 2 / MonRefresh); % Why are we dividing by refresh rate here??? Value = 16 dots, 1 dot if aperture = 1.85
PPD = pi * pixX / atan(cmX/ViewDist/2) / 360; % PPD -- Pixels per degree. 
ApDiamP = round(ApDiam * PPD); % Aperture diameter in pixels
halfdiam = round(ApDiamP/2);

%% More dot parameters - trial related
boundsMain = 45:90:360;
% bounds = 45:90:360;
bounds = [45, 225];
% dirs = [0, 15, 45, 75, 90, 105, 135, 165, 180];
% dirs = [0, 3, 6, 9, 12, 15, 18, 21, 24];
dirs = [0, 3, 6, 9, 12];
% cohs = [0, 3.2, 9, 15, 25.6, 52, 100]/100;
cohs = 1;
resp1 = [111, 107, 108, 112];
resp2 = [108, 112, 111, 107];
feedback = 1;

%% Trial parameters
nTr = 10;
stimTime = 2.5;
nFrames = ceil(stimTime/(1000/MonRefresh));
nCol = 13;
trial = zeros(1, nCol);
trialTab = zeros(nTr, nCol);

HideCursor
%% Start the trial here
for n = 1:nTr
    cIdx = randperm(length(cohs));
    coh = cohs(cIdx(1));
    bIdx = randperm(length(bounds));
    bound = bounds(bIdx(1));
    dIdx = randperm(length(dirs));
    relDir = dirs(dIdx(1));
    if rand < 0.5
        dSign = 1;
    else
        dSign = -1;
    end
    dir = massageDir(bound + dSign*relDir);
    
%     Coh = 0.08;
    gap = 0; % gap is between 0.5 and 2 sec; between 0.2 and 5 seconds for Niwa & Ditterich
    while gap < 0.5
        gap = rand * 2;
    end
    if n==nTr
        iti = 1; % End the last trial early
    else
        iti = 2 + rand*2; % ITI between 2 and 4 seconds; between 5 and 10 for Niwa & Ditterich
    end
	oneDirMotion;
    
    % Feedback
    if feedback == 1
        if dSign == 1
            if double(key) == resp1(find(boundsMain==bound,1))
                Beeper('med');
            else
                Beeper('high');
            end
        else
            if double(key) == resp2(find(boundsMain==bound,1))
                Beeper('med');
            else
                Beeper('high');
            end
        end
    end
    
    trial = [n, stimTime, bound, relDir, dSign, dir, coh*100,  gap, iti, double(key), kt-trStart, keyTime-trStart, trTime];
    trialTab(n,:) = trial;
    
    WaitSecs(iti);
end

Priority(0);
Screen('CloseAll')