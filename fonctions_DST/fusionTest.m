function [savedTrials,abort]=fusionTest(expe,scr,stim,sounds, inputMode, displayMode, calib)
%now test actual fusion objectively and suppression
abort=0;
% ------------- ALLOWED RESPONSES (find the codes in getResponseKb) -----%
%       Response Code Table:
%               3: space
%               4:  escape
%               7:  enter
%               10: numpad 0
%               11: numpad 1
%               12: numpad 2
%               13: numpad 3
%               53: left ctr
%               54: left shift
%--------------------------------------------------------------------------
%   FUSION TEST FOR DOTS
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%   PRE-PROCESSING
%--------------------------------------------------------------------------

%---- trial structure
%   1:  binocularity of trial [1: binocular, 2: left eye only; 3: right eye only]
%   2:  nb of dots [0 to 2]
%tmp=[ones(expe.fusionTestTrialNb,1);2.*ones(expe.fusionTestTrialNb,1);3.*ones(expe.fusionTestTrialNb,1)];

myTrial=1;
for iTask=1
    for nDots=0:2
        for v=1:expe.fusionTestTrialNb1
            CRlistDiplo(myTrial,:)=[iTask,nDots];
            myTrial=myTrial+1;
        end
    end
end
CRlistIdx=randsample(1:size(CRlistDiplo,1),size(CRlistDiplo,1));
CRlistDiplo=CRlistDiplo(CRlistIdx, :);

myTrial=1;
for iTask=2:3
    for nDots=0:1
        for v=1:expe.fusionTestTrialNb2
            CRlistSupp(myTrial,:)=[iTask,nDots];
            myTrial=myTrial+1;
        end
    end
end
CRlistIdx=randsample(1:size(CRlistSupp,1),size(CRlistSupp,1));
CRlistSupp=CRlistSupp(CRlistIdx, :);

CRlist=[CRlistDiplo;CRlistSupp];
firstDiplo=find(CRlist(:,1)==1,1);
firstSupp=find(CRlist(:,1)~=1,1);


%              randomization (uncomment when ready


%--------------------------------------------------------------------------
%   UPDATE LEFT AND RIGHT EYE COORDINATES AND CONTRAST
%--------------------------------------------------------------------------

scr.LcenterXLine= scr.LcenterXLine - calib.leftLeftShift;
scr.LcenterXDot = scr.LcenterXDot - calib.leftLeftShift;
scr.RcenterXLine= scr.RcenterXLine -calib.rightLeftShift;
scr.RcenterXDot = scr.RcenterXDot - calib.rightLeftShift;
scr.LcenterYLine = scr.centerYLine - calib.leftUpShift;
scr.RcenterYLine = scr.centerYLine - calib.rightUpShift;
scr.LcenterYDot = scr.centerYDot - calib.leftUpShift;
scr.RcenterYDot = scr.centerYDot - calib.rightUpShift;

    switch stim.polarity 
        case {1, 4}
            [stim.LmaxL,stim.LminL]=contrSym2Lum(calib.leftContr,scr.backgr); %white and black, left eye
            [stim.LmaxR,stim.LminR]=contrSym2Lum(calib.rightContr,scr.backgr); %white and black, right eye
            colorText = stim.minLum;
            stim.fixL = stim.LminL;
            stim.fixR = stim.LminR;
        case {2}
            stim.LmaxL = stim.minLum + calib.leftContr*(stim.maxLum - stim.minLum);
            stim.LminL = stim.minLum;
            stim.LmaxR = stim.minLum + calib.rightContr*(stim.maxLum - stim.minLum);
            stim.LminR = stim.minLum;
            stim.fixL = stim.LmaxL;
            stim.fixR = stim.LmaxR;
            colorText = stim.maxLum;
        case {3}
            stim.LmaxL = stim.maxLum;
            stim.LminL = stim.maxLum - calib.leftContr*(stim.maxLum - stim.minLum);
            stim.LmaxR = stim.maxLum;
            stim.LminR = stim.maxLum - calib.rightContr*(stim.maxLum - stim.minLum);
            stim.fixL = stim.LminL;
            stim.fixR = stim.LminR;
            colorText = stim.minLum;
    end
%---- frames
stim.horiz.contrast=calib.leftContr;
stim.vert.contrast=calib.leftContr;
horizframeMatL=ultimateGabor(scr.VA2pxConstant, stim.horiz);
vertframeMatL=ultimateGabor(scr.VA2pxConstant, stim.vert);
stim.horiz.contrast=calib.rightContr;
stim.vert.contrast=calib.rightContr;
horizframeMatR=ultimateGabor(scr.VA2pxConstant, stim.horiz);
vertframeMatR=ultimateGabor(scr.VA2pxConstant, stim.vert);

topFrameCoordL=[scr.LcenterXLine-stim.horiz.width/2,scr.LcenterYLine-stim.horiz.height/2-stim.vert.height/2,scr.LcenterXLine+stim.horiz.width/2,scr.LcenterYLine+stim.horiz.height/2-stim.vert.height/2];
topFrameCoordR=[scr.RcenterXLine-stim.horiz.width/2,scr.RcenterYLine-stim.horiz.height/2-stim.vert.height/2,scr.RcenterXLine+stim.horiz.width/2,scr.RcenterYLine+stim.horiz.height/2-stim.vert.height/2];
bottomFrameCoordL=[scr.LcenterXLine-stim.horiz.width/2,scr.LcenterYLine-stim.horiz.height/2+stim.vert.height/2,scr.LcenterXLine+stim.horiz.width/2,scr.LcenterYLine+stim.horiz.height/2+stim.vert.height/2];
bottomFrameCoordR=[scr.RcenterXLine-stim.horiz.width/2,scr.RcenterYLine-stim.horiz.height/2+stim.vert.height/2,scr.RcenterXLine+stim.horiz.width/2,scr.RcenterYLine+stim.horiz.height/2+stim.vert.height/2];
leftFrameL=[scr.LcenterXLine-stim.vert.width/2-stim.horiz.width/2,scr.LcenterYLine-stim.vert.height/2-stim.horiz.height/2,scr.LcenterXLine-stim.horiz.width/2+stim.vert.width/2,scr.LcenterYLine+stim.vert.height/2+stim.horiz.height/2];
leftFrameR=[scr.RcenterXLine-stim.vert.width/2-stim.horiz.width/2,scr.RcenterYLine-stim.vert.height/2-stim.horiz.height/2,scr.RcenterXLine-stim.horiz.width/2+stim.vert.width/2,scr.RcenterYLine+stim.vert.height/2+stim.horiz.height/2];
rightFrameL=[scr.LcenterXLine-stim.vert.width/2+stim.horiz.width/2,scr.LcenterYLine-stim.vert.height/2-stim.horiz.height/2,scr.LcenterXLine+stim.horiz.width/2+stim.vert.width/2,scr.LcenterYLine+stim.vert.height/2+stim.horiz.height/2];
rightFrameR=[scr.RcenterXLine-stim.vert.width/2+stim.horiz.width/2,scr.RcenterYLine-stim.vert.height/2-stim.horiz.height/2,scr.RcenterXLine+stim.horiz.width/2+stim.vert.width/2,scr.RcenterYLine+stim.vert.height/2+stim.horiz.height/2];


horizframeL=Screen('MakeTexture',scr.w,sc(horizframeMatL,scr.box));
vertframeL=Screen('MakeTexture',scr.w,sc(vertframeMatL,scr.box));
horizframeR=Screen('MakeTexture',scr.w,sc(horizframeMatR,scr.box));
vertframeR=Screen('MakeTexture',scr.w,sc(vertframeMatR,scr.box));

%---frame duration
%frameDurationSec=scr.frameTime;
%--------------------------------------------------------------------------
%   START TRIAL LOOP
%--------------------------------------------------------------------------
savedTrials=nan(size(CRlist,1),3); goalCounter=size(CRlist,1);
for myTrial=1:size(CRlist,1)
    
  
    %--- initialize trial parameters
    binoType=CRlist(myTrial,1); %1 bino 2 left eye only 3 right eye only
    nbDots=CRlist(myTrial,2); %correct response - nb of dots in circles
    
    %---initialize circles coordinates
    %left eye
    LcirclesX1=rand(1,expe.fusionTestcircleNb1); %describe position as a pourcentage along the virtual axis in which it is (n boxes for each quadrant)
    LcirclesX2=rand(1,expe.fusionTestcircleNb1); %right set of circles
    marge=stim.outFusFrameHeight/(2*expe.fusionTestcircleNb1);
    rangeX=stim.outFusFrameWidth-stim.circleSize;
    LcirclesY=(1:2:expe.fusionTestcircleNb1*2).*marge-stim.outFusFrameHeight/2;
    LcirclesXY1=[-LcirclesX1.*rangeX-stim.outFusFrameEcc+scr.LcenterXLine-stim.circleSize/2;LcirclesY+scr.LcenterYLine];
    LcirclesXY2=[LcirclesX2.*rangeX+stim.outFusFrameEcc+scr.LcenterXLine+stim.circleSize/2;LcirclesY+scr.LcenterYLine];
    LcirclesXY=[LcirclesXY1,LcirclesXY2];
    LcirclesRect1=[LcirclesXY1-stim.circleSize/2;LcirclesXY1+stim.circleSize/2] ;
    LcirclesRect2=[LcirclesXY2-stim.circleSize/2;LcirclesXY2+stim.circleSize/2] ;
    LcirclesRect=[LcirclesRect1,LcirclesRect2];
    
    %right eye
    RcirclesXY1=[-LcirclesX1.*rangeX-stim.outFusFrameEcc+scr.RcenterXLine-stim.circleSize/2;LcirclesY+scr.RcenterYLine];
    RcirclesXY2=[LcirclesX2.*rangeX+stim.outFusFrameEcc+scr.RcenterXLine+stim.circleSize/2;LcirclesY+scr.RcenterYLine];
    RcirclesXY=[RcirclesXY1,RcirclesXY2];
    RcirclesRect1=[RcirclesXY1-stim.circleSize/2;RcirclesXY1+stim.circleSize/2] ;
    RcirclesRect2=[RcirclesXY2-stim.circleSize/2;RcirclesXY2+stim.circleSize/2] ;
    RcirclesRect=[RcirclesRect1,RcirclesRect2];
    
    %Select the correct number of dots
    if nbDots>0
        selectedDots=randsample(2*expe.fusionTestcircleNb1,nbDots);
        LcirclesXY = LcirclesXY(:,selectedDots);
        RcirclesXY = RcirclesXY(:,selectedDots);
    end
    %---initialize timers
    onsetStimIni=GetSecs;
    onsetStim=onsetStimIni;
    
    %--------------------------------------------------------------------------
    %   START STIMULUS LOOP
    %--------------------------------------------------------------------------
    while onsetStim<onsetStimIni+stim.duration/1000%while presentation time is not over
        %--------------------------------------------------------------------------
        %   DISPLAY FRAMES + FIXATION + CIRCLES/DOTS
        %--------------------------------------------------------------------------
        
        %--- Background
        Screen('FillRect', scr.w, sc(scr.backgr,scr.box));
       
        
        if myTrial==firstDiplo
            allowR=[3,4,7,10:13,52];
            Screen('TextSize', scr.w,30 );
            Screen('DrawText', scr.w, '   Diplopia Task', scr.centerX, 200, sc(colorText,scr.box))
            flip2(inputMode, scr.w);
            waitForKey(scr.keyboardNum,inputMode)
        elseif myTrial==firstSupp
            allowR=[3,4,10:11];
            Screen('TextSize', scr.w,30 );
            Screen('DrawText', scr.w, ' Suppression Task', scr.centerX, 200, sc(colorText,scr.box))
            flip2(inputMode, scr.w);
            waitForKey(scr.keyboardNum,inputMode)
        end
            
            
        
        %---- frames
%        Screen('DrawTextures',scr.w,[horizframeL,horizframeR,horizframeL,horizframeR,vertframeL,vertframeR,vertframeL,vertframeR],[],[topFrameCoordL',topFrameCoordR',bottomFrameCoordL',bottomFrameCoordR',leftFrameL',leftFrameR',rightFrameL',rightFrameR'])
        
         %REPLACE HASHED FRAMES WITH AN HOMOGENOUS ONE
    Screen('FrameRect', scr.w, sc(stim.fixL,scr.box),[scr.LcenterXLine-stim.horiz.width/2,scr.LcenterYLine-stim.vert.height/2,scr.LcenterXLine+stim.horiz.width/2,scr.LcenterYLine+stim.vert.height/2], stim.horiz.height)
    Screen('FrameRect', scr.w, sc(stim.fixR,scr.box),[scr.RcenterXLine-stim.horiz.width/2,scr.RcenterYLine-stim.vert.height/2,scr.RcenterXLine+stim.horiz.width/2,scr.RcenterYLine+stim.vert.height/2], stim.horiz.height)
   
        %-----fixation
        drawDichFixation(scr,stim);
        
%         %vertical lines
%         Screen('DrawLine', scr.w, sc(stim.LminL,scr.box), scr.LcenterXLine, scr.LcenterYLine+stim.fixationOffset ,  scr.LcenterXLine, scr.LcenterYLine+stim.fixationLength+stim.fixationOffset , stim.fixationLineWidth);   %Left eye up line
%         Screen('DrawLine', scr.w, sc(stim.LminR,scr.box), scr.RcenterXLine, scr.RcenterYLine-stim.fixationOffset,  scr.RcenterXLine, scr.RcenterYLine-stim.fixationLength-stim.fixationOffset , stim.fixationLineWidth);   %right eye down line
%         Screen('DrawLine', scr.w, sc(stim.LminL,scr.box), scr.LcenterXLine, scr.LcenterYLine-stim.fixationOffset ,  scr.LcenterXLine, scr.LcenterYLine-stim.fixationLength-stim.fixationOffset , stim.fixationLineWidth);   %Left eye up line
%         Screen('DrawLine', scr.w, sc(stim.LminR,scr.box), scr.RcenterXLine, scr.RcenterYLine+stim.fixationOffset,  scr.RcenterXLine, scr.RcenterYLine+stim.fixationLength+stim.fixationOffset , stim.fixationLineWidth);   %right eye down line
%         %horizontal
%         Screen('DrawLine', scr.w, sc(stim.LminL,scr.box), scr.LcenterXLine-round(stim.fixationLength), scr.LcenterYLine,  scr.LcenterXLine-stim.fixationOffset, scr.LcenterYLine , stim.fixationLineWidth);   %Left eye left horizontal line
%         Screen('DrawLine', scr.w, sc(stim.LminL,scr.box), scr.LcenterXLine+stim.fixationOffset, scr.LcenterYLine,  scr.LcenterXLine+round(stim.fixationLength), scr.LcenterYLine , stim.fixationLineWidth);   %Left eye right horizontal line
%         Screen('DrawLine', scr.w, sc(stim.LminR,scr.box), scr.RcenterXLine+round(stim.fixationLength), scr.RcenterYLine,  scr.RcenterXLine+stim.fixationOffset, scr.RcenterYLine , stim.fixationLineWidth);   %right eye left horizontal line
%         Screen('DrawLine', scr.w, sc(stim.LminR,scr.box), scr.RcenterXLine-stim.fixationOffset, scr.RcenterYLine,  scr.RcenterXLine-round(stim.fixationLength), scr.RcenterYLine , stim.fixationLineWidth);   %right eye right horizontal line
%         %centre frame
%         maxi=round(stim.fixationLength+2*stim.fixationOffset);
%         Screen('FrameOval', scr.w ,sc(stim.LminL,scr.box) ,[scr.LcenterXLine-1-maxi scr.LcenterYLine-1-maxi scr.LcenterXLine+1+maxi scr.LcenterYLine+1+maxi] ,stim.fixationLineWidth) ;
%         Screen('FrameOval', scr.w ,sc(stim.LminR,scr.box) ,[scr.RcenterXLine-1-maxi scr.RcenterYLine-1-maxi scr.RcenterXLine+1+maxi scr.RcenterYLine+1+maxi] ,stim.fixationLineWidth);
%         %Middle binocular fixation dot
%         Screen('DrawDots', scr.w, [LcenterXDot;LcenterYDot], stim.fixationDotSize,sc(stim.LminL,scr.box));
%         Screen('DrawDots', scr.w, [RcenterXDot;RcenterYDot], stim.fixationDotSize,sc(stim.LminR,scr.box));
%         %                    %Centre frame
%         %                       maxi=round(stim.fixationLength+2*stim.fixationOffset);
%         %                       Screen('FrameRect', scr.w ,sc(stim.LminL,scr.box) ,[scr.LcenterXLine-1-maxi scr.LcenterYLine-1-maxi scr.LcenterXLine+1+maxi scr.LcenterYLine+1+maxi] ,stim.fixationLineWidth) ;
%         %                       Screen('FrameRect', scr.w ,sc(stim.LminR,scr.box) ,[scr.RcenterXLine-1-maxi scr.RcenterYLine-1-maxi scr.RcenterXLine+1+maxi scr.RcenterYLine+1+maxi] ,stim.fixationLineWidth);
%         
        %---Peripheric frames
%         Screen('FrameRect', scr.w ,sc(stim.LminL,scr.box) ,[scr.LcenterXLine-stim.outFusFrameEcc-stim.outFusFrameWidth scr.LcenterYLine-stim.outFusFrameHeight/2 scr.LcenterXLine-stim.outFusFrameEcc scr.LcenterYLine+stim.outFusFrameHeight/2] ,stim.fixationLineWidth) ;
%         Screen('FrameRect', scr.w ,sc(stim.LminR,scr.box) ,[scr.RcenterXLine-stim.outFusFrameEcc-stim.outFusFrameWidth scr.RcenterYLine-stim.outFusFrameHeight/2 scr.RcenterXLine-stim.outFusFrameEcc scr.RcenterYLine+stim.outFusFrameHeight/2] ,stim.fixationLineWidth);
%         Screen('FrameRect', scr.w ,sc(stim.LminL,scr.box) ,[scr.LcenterXLine+stim.outFusFrameEcc scr.LcenterYLine-stim.outFusFrameHeight/2 scr.LcenterXLine+stim.outFusFrameEcc+stim.outFusFrameWidth scr.LcenterYLine+stim.outFusFrameHeight/2] ,stim.fixationLineWidth) ;
%         Screen('FrameRect', scr.w ,sc(stim.LminR,scr.box) ,[scr.RcenterXLine+stim.outFusFrameEcc scr.RcenterYLine-stim.outFusFrameHeight/2 scr.RcenterXLine+stim.outFusFrameEcc+stim.outFusFrameWidth scr.RcenterYLine+stim.outFusFrameHeight/2] ,stim.fixationLineWidth);
%         
        %---Circles
        Screen('FrameOval',  scr.w, sc(stim.fixL,scr.box), LcirclesRect, stim.circleLineWidth);
        Screen('FrameOval',  scr.w, sc(stim.fixR,scr.box), RcirclesRect, stim.circleLineWidth);
        
        %---Dots
        if nbDots>0
            if binoType==2
                Screen('DrawDots', scr.w, LcirclesXY ,stim.dotSize, sc(stim.fixL,scr.box), [] ,1);
            elseif binoType==3
                Screen('DrawDots', scr.w, RcirclesXY ,stim.dotSize, sc(stim.fixR,scr.box), [] ,1);
            else
                Screen('DrawDots', scr.w, LcirclesXY ,stim.dotSize, sc(stim.fixL,scr.box), [] ,1);
                Screen('DrawDots', scr.w, RcirclesXY ,stim.dotSize, sc(stim.fixR,scr.box), [] ,1);
            end
        end
        %-------- FLIP ------------------------------------------
        [dummy onsetStim]=flip2(inputMode, scr.w);
        %--------------------------------------------------------------------------
        
    end
    
    %--- Background - to erase stimuli
    Screen('FillRect', scr.w, sc(scr.backgr,scr.box));
    %--------------------------------------------------------------------------
    %   GET RESPONSE
    %--------------------------------------------------------------------------
    [responseKey, RT]=getResponseKb(scr.keyboardNum,0,inputMode,allowR,'robotModeDSTv1',[binoType,nbDots]);
    
    % --- ESCAPE PRESS : escape the whole program ----%
    if responseKey==4
        disp('Voluntary Interruption')
        warnings
        precautions(scr.w, 'off');
        return
    end
    

    if inputMode==1
      
     % play(sounds.success.obj)
      
    end
    %--------------------------------------------------------------------------
    %   SAVE TRIAL
    %--------------------------------------------------------------------------
    
    response=responseKey-10;
    if response == 42 || response == 7 %special case of enter numpag key
        response = 4;
    end
    savedTrials(myTrial,:)=[binoType, nbDots,response];
    
    %------ Progression bar for robotMode ----%
    if inputMode==2
        Screen('FillRect',scr.w, sc([scr.fontColor,0,0],scr.box),[0 0 scr.res(3)*myTrial/goalCounter 10]);
        Screen('Flip',scr.w);
    end
    
    %----------- SPACE PRESS - Go back to calibration --------%
    if responseKey==3
        abort=1;
        break
    end
end
end
