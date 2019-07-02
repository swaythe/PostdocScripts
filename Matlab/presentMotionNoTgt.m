%% General parameters
subject = 'sub01';
% The possible bound values are 45 and 135
bound = 135;
feedback = 1;

cd('/Users/kayserlab/Documents/DotsSS/Scripts/Categorization/')
dataFolder = 'Data/Behavior/';

if ~exist([dataFolder, subject], 'dir')
    runFolder = 'run1';
    mkdir([dataFolder, subject, '/', runFolder]);
else
    subDir = dir([dataFolder, subject, '/run*']);
    runFolder = ['run', num2str(length(subDir)+1)];
    mkdir([dataFolder, subject, '/', runFolder]);
end

% Response-related parameters
% Correct response is '1' for [45 or 135]+[0:90] and 
% '2' for [45 or 135]-[0:90]
resp = [49 50]; %'1' or '2'
scannerInput = 53; %'5'

%% File stuff
% Get ITIs from an OptSeq file
osRnd = randperm(20);
osDir = '/Users/kayserlab/Documents/trSeq-0';
optSeqFile = [osDir, num2str(osRnd(1)), '.par'];
sMat = textscan(fopen(optSeqFile), '%f %f %f %f %s');
dur = sMat{3};
didx = 2:2:length(dur);
ITIs = dur(didx);

% Load file with direction and coherence values permuted
load([dataFolder, 'DirCohSS'])
dirCoh = DirCohSS(randperm(length(DirCohSS)),:);

% Data saving stuff
runFolder = [dataFolder, subject, '/', runFolder, '/'];
% Turn on diary
diary([runFolder, subject, '.diary']);
% Open a new text file to save data
fid = fopen([runFolder, subject '.txt'], 'a+');
fprintf(fid, 'Subject: %s\n', subject);
fprintf(fid, 'OptSeq file: %s\n', optSeqFile);
fprintf(fid, 'Data column headers:\n');
fprintf(fid, 'Trial# TTL_time1 TTL_time2 Trial_start Stim_start Stim_durn Bound Relative_dir Dir Coh Resp1 Resp2 RT1 RT2 Delta_time RT3 Accuracy ITI_start ITI_durn Trial_durn\n');

%% Some screen parameters
ImageMode = 0;
ScreenNumbers = Screen('Screens',1);
CurScreen = ScreenNumbers(1);
BGColor = 0;

AssertOpenGL;
HideCursor;
KillUpdateProcess;

Screen('Preference', 'VisualDebugLevel', 2);
Screen('Preference', 'SkipSyncTests', 0);

%% Determine current window and screen size in pixel coordinates
global Center CurWindow BuffClear;

BuffClear = 0;
[CurWindow, SR] = Screen('OpenWindow', 0, BGColor, [150,150,1200,700], 32, 2, 0, [], ImageMode); % Remove the rect definition for the actual exp
% [CurWindow, SR] = Screen('OpenWindow', 0, BGColor, [], 32, 2, 0, [], ImageMode); 
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

%% Trial parameters
nTr = 1;
stimTime = 2.5;
nFrames = ceil(stimTime/(1000/MonRefresh));

%% Show boundary condition at the start of the run
HideCursor
showTgt

%% Wait for scanner TTL before starting the trials
scanTTL = 0;
scanTTLtimes1 = [];
scanTTLtimes2 = [];

FlushEvents;
olddisabledkeys = DisableKeysForKbCheck([1:29 32 33 35:88 91 92 94:256]);
while ~scanTTL
    if CharAvail
        [metaKey, scanTTLtime2, key2, dTime] = KbCheck;
        [key1, scanTTLtime1] = GetChar;
        if double(key1) == scannerInput
            scanTTL = 1;
        end
    end
end
scanTTLtimes1 = [scanTTLtimes1, scanTTLtime1.secs];
scanTTLtimes2 = [scanTTLtimes2, scanTTLtime2];

%% Start the trial here
for n = 1:nTr
    relDir = dirCoh(n,1);
    coh = dirCoh(n,2);
    dirn = massageDir(bound + relDir);

    iti = ITIs(n);
    acc = 0;
	oneDirMotionNoTgt;
    
    % Feedback
    if feedback == 1
        if sign(relDir) == 1
            if double(key1) == resp(1)
                Beeper('med');
                acc = 1;
            else
                Beeper('high');
            end
        else
            if double(key1) == resp(2)
                Beeper('med');
                acc = 1;
            else
                Beeper('high');
            end
        end
    end
    itiStart = GetSecs;
    if n ~= nTr
        WaitSecs(iti);
    else
        WaitSecs(1);
    end    
    trEnd = GetSecs;
    trTime = trEnd - trStart;
    
    trial = [n, scanTTLtime1.secs, scanTTLtime2, trStart, stimStart, stimTime, bound, relDir, dirn, coh*100, double(key1), find(key2), RT1.secs, RT2, dTime, keyTime, acc, itiStart, iti, trTime];
    if n == 1
        nCol = length(trial);
        trialTab = zeros(nTr, nCol);
    end
    fprintf(fid, '%d %.6f %.6f %.6f %.6f %.2f %d %d %d %.1f %d %d %.6f %.6f %.6f %.6f %d %.6f %.4f %.6f\n', trial);
    trialTab(n,:) = trial;
end

Priority(0);
Screen('CloseAll')
fclose(fid);
save([runFolder, subject, '.mat'], 'trialTab', 'scanTTLtimes1', 'scanTTLtimes2');
diary off;
