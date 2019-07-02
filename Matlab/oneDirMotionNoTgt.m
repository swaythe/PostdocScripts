DotMotion = repmat(DotSpeed/ApDiam * (3/MonRefresh) * [cos(pi*dirn/180.0), -sin(pi*dirn/180.0)], DotNum,1);

% NEW METHOD: dot motion values for 360 degrees
% Why is velocity a multi-dim matrix?? Because it's actually providing [x,y] jump values for dots. 
Velocity = zeros(360,2);
for index = 1:360
    Velocity(index,:) = DotSpeed/ApDiam * (3/MonRefresh) * [cos(pi*(index-1)/180.0), -sin(pi*(index-1)/180.0)];
end

% Create random initial positions for the dots. Perform a check first to see that
% the dots are more-or-less uniformly located and not bunched together.
DotPosition = rand(DotNum*3,2);
Out = checkDotPos(DotPosition, DotNum); 
while Out ~= 0
    DotPosition = rand(DotNum*3,2);
    Out = checkDotPos(DotPosition, DotNum); 
end

% Divide dots into three sets...
% The below equation produces a DotNumx3 matrix and its contents are 1..DotNum*3 in column-major order
% This is just to produce indices for the 3 interleaved frames that produce the impression of motion
DotMarks = cumsum(ones(DotNum,3))+repmat([0 DotNum DotNum*2], DotNum, 1); 

% initialize the dot frame variable
dotframe = 1;

PriorityLevel = MaxPriority(CurWindow,'KbCheck');
Priority(PriorityLevel);

% Some aperture variables
ApPlot = [(Center(1) - halfdiam) (Center(2) - halfdiam) (Center(1) + halfdiam) (Center(2) + halfdiam)];
SquarePlot = ApPlot + [-10 -10 10 10];

% How dots are presented: 1 group of dots are shown in the first frame, a
% second group are shown in the second frame, a third group shown in the
% third frame. in the next frame, some percentage of the dots from the
% first frame are replotted according to the speed/direction and coherence,
% the next frame the same is done for the second group, etc.
FlushEvents;
trStart = GetSecs;
showFix([200 200 200 0]);
if n == 1
    WaitSecs(2);
end
dimFix;
% WaitSecs(5);
stimStart = GetSecs;

% Show motion
validKey = 0;
waitLoop = 1;
tic;
while waitLoop
    interval = toc;
    if interval >= stimTime
        waitLoop = 0;
        continue;
    end
	DotMarksFrame = DotMarks(:,dotframe);  % dotframe is 1 and DotMarks is the 3-col matrix which has numbers from 1 to DotNum 
	% So DotMarksFrame becomes either 1:16, 17:32 or 33:48 if DotNum=16 
	
	% This now has the dot positions from 3 frames ago, which is what is then moved in the current loop
	% This is a matrix of random #s - starting positions for dots not moving coherently
	DotPositionFrame = DotPosition(DotMarksFrame,:);

	% Calculate dot motion

    % To get coherent motion in 3 directions, here's what I'm going to do:
    % Use the existing method of rand(DotNum) < Coh(i) to figure out how
    % many dots will move in the direction Dir(i). Then do a randperm of 16
    % to find the indices of the DotPositionFrame metrix that will belong
    % to each direction.
    rp = randperm(DotNum);
    
	% The line below gives a 1 for some dots at random that should move in the given direction, the
	% other dots are given values of 0 to indicate random motion SS
    % => L==1 represents coherent motion and L==0 represents rnd motion SS
    L = 0;
    chkL = 0;
    while chkL == 0
        L = sum(rand(DotNum,1) < coh);        
        if L <= DotNum; chkL = 1; end
    end
    
    % Get the required number of dots moving coherently in each of the
    % directions 
    DotPositionFrame(rp(1:L),:) = DotPositionFrame(rp(1:L),:) + DotMotion(rp(1:L),:,1);
     
	whatsleft = DotNum - L;
	if whatsleft > 0
		RandomMotion = zeros(whatsleft,2);
		RMPtrs = rp(L+1:end);
		for index = 1:whatsleft
			RandomMotion(index,:) = Velocity(ceil(rand*360),:);
		end
		% Get new random locations for the rest
		DotPositionFrame(RMPtrs,:) = DotPositionFrame(RMPtrs,:) + RandomMotion;
	end
	% Wrap around - check to see if any positions are greater than one or less than zero
	% which is out of the square aperture, and then replace with a dot along one
	% of the edges opposite from the edge it moved across.
    % N contains the indices of the dots we want to replot 'cos they exceed bounds
	N = sum(DotPositionFrame > 1 | DotPositionFrame < 0, 2) ~= 0;
	DotOut = DotPositionFrame(N,:);
	for index = 1:sum(N)
		if DotOut(index,1) > 1,
			DotOut(index,1) = Velocity(1,1);
		elseif DotOut(index,1) < 0,
			DotOut(index,1) = 1 - Velocity(1,1);
		else
			DotOut(index,1) = rand;
		end
		if DotOut(index,2) > 1,
			DotOut(index,2) = Velocity(271,2);
		elseif DotOut(index,2) < 0,
			DotOut(index,2) = 1 - Velocity(271,2);
		else
			DotOut(index,2) = rand;
		end
	end
	
	DotPositionFrame(N,:) = DotOut;
    
    % Convert to stuff we can actually plot
    DotPositionPlot = floor(ApDiamP * DotPositionFrame);	% pix/ApUnit

    % This assumes that zero is at the top left, but we want it to be in the center
    %(for the DrawDots function), so shift the dots up and left, which just means
    % adding half of the aperture size to both the x and y direction.
    DotShow = (DotPositionPlot - ApDiamP/2)';

    % Update the loop pointer
	% We switch between 3 frames, so make sure index never exceeds 3
    dotframe = dotframe+1;
    if dotframe == 4,
        dotframe = 1;
    end

    % This will cover up the edges of the rectangle area of dots, leaving
    % only a circular region visible
    Screen('BlendFunction', CurWindow, GL_ONE, GL_ZERO); % GL_ONE AND GL_ZERO are ptb constants SS
    % Square that dots do not show up in
    showFix([hue hue hue 0]);
    Screen('FillRect', CurWindow, [0 0 0 0], SquarePlot);
    

    % Circle that dots do show up in
    Screen('FillOval', CurWindow, [0 0 0 255], ApPlot);    
    Screen('BlendFunction', CurWindow, GL_DST_ALPHA, GL_ONE_MINUS_DST_ALPHA);

    % This will draw the dots
	Screen('DrawDots', CurWindow, DotShow, DotSize, DotColor, Center);
    Screen('Flip', CurWindow, 0, BuffClear);
    
    % Tell ptb to get ready while doing computations for next dots presentation
    Screen('DrawingFinished', CurWindow, BuffClear);
    Screen('BlendFunction', CurWindow, GL_ONE, GL_ZERO);

    % Increment the frame number
    DotPosition(DotMarksFrame,:) = DotPositionFrame;
    if validKey == 0
        if CharAvail
            [key1, RT1] = GetChar;
            [metaKey, RT2, key2, dTime] = KbCheck;
            if key1 == '1' || key1 == '2' % For actual experiment using button pad
                keyTime = GetSecs;
    %             disp('Valid key pressed')
                validKey = 1;
            end
            FlushEvents;
        end
    end
end

%% Present response screen
Screen('FillRect', CurWindow, [0 0 0 0], SquarePlot);
Screen('Flip', CurWindow, 0, BuffClear);

% Screen('FillOval', CurWindow, [200 0 0], [tgt1Pos, tgt1Pos+tgtSize]);
% Screen('FillOval', CurWindow, [200 0 0], [tgt2Pos, tgt2Pos+tgtSize]);
% Screen('FillOval', CurWindow, [200 0 0], [tgt3Pos, tgt3Pos+tgtSize]);
% Screen('FillOval', CurWindow, [200 0 0], [tgt4Pos, tgt4Pos+tgtSize]);
showFix([200 200 200 0])
% Screen('Flip', CurWindow, 0, BuffClear);
if validKey == 0
    FlushEvents;
    waitStim = 1;
    while waitStim
        interval = toc;
        if interval >= 0.5
            waitStim = 0;
            continue;
        end
        if CharAvail
            kt = GetSecs;
            [key1, RT1] = GetChar;
            [metaKey, RT2, key2, dTime] = KbCheck;
            if key1 == '1' || key1 == '2' % For actual experiment using button pad
                keyTime = GetSecs;
    %             disp('Valid key pressed')
                validKey = 1;
                waitStim = 0;
            elseif key1 == '5'
                scanTTLtimes1 = [scanTTLtimes1, scanTTLtime1.secs];
                scanTTLtimes2 = [scanTTLtimes2, scanTTLtime2];
            end
            FlushEvents;
        end
    end
    if validKey == 0
        RT1.secs = NaN;
        RT2 = NaN;
        keyTime = NaN;
        key1 = '0';
        key2 = '0';
    end
end
% Screen('FillRect', CurWindow, [0 0 0 0], SquarePlot);
% Screen('Flip', CurWindow, 0, BuffClear);


