tgtOffset = 75;
tgtSize = 20;
lineWidth = 3;
BuffClear = 0;

ApPlot = [(Center(1) - halfdiam) (Center(2) - halfdiam) (Center(1) + halfdiam) (Center(2) + halfdiam)];
SquarePlot = ApPlot + [-10 -10 10 10];    

tgt1 = massageDir(bound + 90);
tgt2 = massageDir(bound - 90);
tgt3 = bound;
tgt4 = massageDir(bound + 180);
tgt1X = (halfdiam + tgtOffset) * cos(tgt1*pi/180);
tgt2X = -(halfdiam + tgtOffset) * cos(tgt2*pi/180);
tgt3X = (halfdiam + tgtOffset) * cos(tgt3*pi/180);
tgt4X = -(halfdiam + tgtOffset) * cos(tgt4*pi/180);
tgt1Y = -floor((halfdiam + tgtOffset) * sin(tgt1*pi/180));
tgt2Y = floor((halfdiam + tgtOffset) * sin(tgt2*pi/180));
tgt3Y = -floor((halfdiam + tgtOffset) * sin(tgt3*pi/180));
tgt4Y = floor((halfdiam + tgtOffset) * sin(tgt4*pi/180));
tgt1Pos = Center + [tgt1X, tgt1Y];
tgt2Pos = Center - [tgt2X, tgt2Y];
tgt3Pos = Center + [tgt3X, tgt3Y];
tgt4Pos = Center - [tgt4X, tgt4Y];

Screen('FillRect', CurWindow, [0 0 0 0], SquarePlot);
Screen('Flip', CurWindow, 0, BuffClear);

Screen('FillOval', CurWindow, [200 0 0], [tgt1Pos, tgt1Pos+tgtSize]);
Screen('FillOval', CurWindow, [200 0 0], [tgt2Pos, tgt2Pos+tgtSize]);
Screen('DrawLine', CurWindow, [200 200 200], tgt3Pos(1), tgt3Pos(2), tgt4Pos(1), tgt4Pos(2), lineWidth);
Screen('Flip', CurWindow, 0, BuffClear);

WaitSecs(5)

Screen('FillRect', CurWindow, [0 0 0 0], SquarePlot);
Screen('Flip', CurWindow, 0, BuffClear);
