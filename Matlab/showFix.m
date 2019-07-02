function showFix(FixColor)
    % FixColor = [200 200 200 0];
    global Center CurWindow BuffClear FixAp;
    FixArmLength = 15;
    FixWd = 1.5;

    FixArm1 = [(Center(1) - FixArmLength) (Center(2) - FixWd) ...
                    (Center(1) + FixArmLength) (Center(2) + FixWd)];
    FixArm2 = [(Center(1) - FixWd) (Center(2) - FixArmLength) ...
                    (Center(1) + FixWd) (Center(2) + FixArmLength)];
    FixAp = [(Center(1) - (FixArmLength+4)) (Center(2) - (FixArmLength+4)) ...
                  (Center(1) + (FixArmLength+4)) (Center(2) + (FixArmLength+4))];


%     Screen('BlendFunction', CurWindow, GL_ONE, GL_ZERO);
    Screen('FillRect', CurWindow, FixColor, FixArm1);
    Screen('FillRect', CurWindow, FixColor, FixArm2);                
    Screen('Flip', CurWindow, 0, BuffClear);
