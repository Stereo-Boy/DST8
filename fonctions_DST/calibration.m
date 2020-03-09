%============ STIMULUS PRESENTATION AND RESPONSE INTAKE ======================================
function [calib,stim]=calibration(expe,scr,stim,sounds, inputMode, displayMode,calib)

%--------------------------------------------------------------------------
%  Keys
%--------------------------------------------------------------------------
% left, right, up, down control left  and righteye position
% q and a are increasing and decreasing left eye contrast
% w and s are increasing and decreasing right eye contrast
% e and d are increasing and decreasing flickering frequency
% Space validates the setting
% Esc quits without saving

% ------------- ALLOWED RESPONSES (find the codes in getResponseKb) -----%
%       Response Code Table:
%               0:  no keypress before time limit
%               1:  left
%               2:  right
%               3:  space
%               4:  escape
%               5:  up
%               6:  down
%               7:  enter
%               12: numpad 2
%               18: numpad 8
%               14: numpad 4
%               16: numpad 6
%               20: a
%               36: q
%               42: w
%               38: s
%               24: e
%               23: d
%               49-53 - numbers 1 to 5
%               53: left ctr
%               54: left shift
allowR=[1:6,53,54];

%         %--------------------------------------------------------------------------
%         %   PRELOADING OF TEXTURES DURING INTERTRIAL
%         %--------------------------------------------------------------------------
%             if ~exist('beginInterTrial','var'); beginInterTrial=GetSecs;end
%             masks(:,:,1)=sc(stim.maskLum.*rand(stim.frameSize),scr.box);
%             masks(:,:,2)=sc(stim.maskLum.*rand(stim.frameSize),scr.box);
%             text1 = Screen('MakeTexture', scr.w, masks(:,:,1));
%             text2 = Screen('MakeTexture', scr.w, masks(:,:,2));
%             clear masks
%             feuRouge(beginInterTrial+stim.interTrial/1000,inputMode);


%--------------------------------------------------------------------------
%   LOOP TO ALLOW CALIBRATION
%--------------------------------------------------------------------------
calib.leftContrNum=log(calib.leftContr/(1-calib.leftContr)); %a number that we vary between -inf and inf and that we map betw 0 and 1 with a sigmoid
calib.rightContrNum=log(calib.rightContr/(1-calib.rightContr));

    scr.LcenterXLineIni= scr.LcenterXLine ;
    scr.LcenterXDotIni = scr.LcenterXDot  ;
    scr.RcenterXLineIni= scr.RcenterXLine  ;
    scr.RcenterXDotIni = scr.RcenterXDot  ;
    
goFlag=1;
while goFlag==1
    
    %--------------------------------------------------------------------------
    %   UPDATE LEFT AND RIGHT EYE COORDINATES AND CONTRAST
    %--------------------------------------------------------------------------
        
    scr.LcenterXLine= scr.LcenterXLineIni - calib.leftLeftShift;
    scr.LcenterXDot = scr.LcenterXDotIni - calib.leftLeftShift;
    scr.RcenterXLine= scr.RcenterXLineIni - calib.rightLeftShift;
    scr.RcenterXDot = scr.RcenterXDotIni - calib.rightLeftShift;
    scr.LcenterYLine = scr.centerYLine - calib.leftUpShift;
    scr.RcenterYLine = scr.centerYLine - calib.rightUpShift;
    scr.LcenterYDot = scr.centerYDot - calib.leftUpShift;
    scr.RcenterYDot = scr.centerYDot - calib.rightUpShift;
    calib.leftContr=1./(1+exp(-calib.leftContrNum));
    calib.rightContr=1./(1+exp(-calib.rightContrNum));
    switch stim.polarity %1 : standard with grey background, 2: white on black background, 3: black on white background
        %4: half black and half white on grey background
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
    %--------------------------------------------------------------------------
    %   DISPLAY FRAMES + FIXATION
    %--------------------------------------------------------------------------
    
    
    %---- frames
    %--------------------------------------------------------------------------
    stim.horiz.contrast=calib.leftContr;
    stim.vert.contrast=calib.leftContr;
%     horizframeMatL=ultimateGabor(scr.VA2pxConstant, stim.horiz);
%     vertframeMatL=ultimateGabor(scr.VA2pxConstant, stim.vert);
    stim.horiz.contrast=calib.rightContr;
    stim.vert.contrast=calib.rightContr;
%     horizframeMatR=ultimateGabor(scr.VA2pxConstant, stim.horiz);
%     vertframeMatR=ultimateGabor(scr.VA2pxConstant, stim.vert);
%   
%     topFrameCoordL=[scr.LcenterXLine-stim.horiz.width/2,scr.LcenterYLine-stim.horiz.height/2-stim.vert.height/2,scr.LcenterXLine+stim.horiz.width/2,scr.LcenterYLine+stim.horiz.height/2-stim.vert.height/2];
%     
%     
%     topFrameCoordR=[scr.RcenterXLine-stim.horiz.width/2,scr.RcenterYLine-stim.horiz.height/2-stim.vert.height/2,scr.RcenterXLine+stim.horiz.width/2,scr.RcenterYLine+stim.horiz.height/2-stim.vert.height/2];
%     bottomFrameCoordL=[scr.LcenterXLine-stim.horiz.width/2,scr.LcenterYLine-stim.horiz.height/2+stim.vert.height/2,scr.LcenterXLine+stim.horiz.width/2,scr.LcenterYLine+stim.horiz.height/2+stim.vert.height/2];
%     bottomFrameCoordR=[scr.RcenterXLine-stim.horiz.width/2,scr.RcenterYLine-stim.horiz.height/2+stim.vert.height/2,scr.RcenterXLine+stim.horiz.width/2,scr.RcenterYLine+stim.horiz.height/2+stim.vert.height/2];
%     leftFrameL=[scr.LcenterXLine-stim.vert.width/2-stim.horiz.width/2,scr.LcenterYLine-stim.vert.height/2-stim.horiz.height/2,scr.LcenterXLine-stim.horiz.width/2+stim.vert.width/2,scr.LcenterYLine+stim.vert.height/2+stim.horiz.height/2];
%     leftFrameR=[scr.RcenterXLine-stim.vert.width/2-stim.horiz.width/2,scr.RcenterYLine-stim.vert.height/2-stim.horiz.height/2,scr.RcenterXLine-stim.horiz.width/2+stim.vert.width/2,scr.RcenterYLine+stim.vert.height/2+stim.horiz.height/2];
%     rightFrameL=[scr.LcenterXLine-stim.vert.width/2+stim.horiz.width/2,scr.LcenterYLine-stim.vert.height/2-stim.horiz.height/2,scr.LcenterXLine+stim.horiz.width/2+stim.vert.width/2,scr.LcenterYLine+stim.vert.height/2+stim.horiz.height/2];
%     rightFrameR=[scr.RcenterXLine-stim.vert.width/2+stim.horiz.width/2,scr.RcenterYLine-stim.vert.height/2-stim.horiz.height/2,scr.RcenterXLine+stim.horiz.width/2+stim.vert.width/2,scr.RcenterYLine+stim.vert.height/2+stim.horiz.height/2];
%     
    
    
    
    
%     horizframeL=Screen('MakeTexture',scr.w,sc(horizframeMatL,scr.box));
%     vertframeL=Screen('MakeTexture',scr.w,sc(vertframeMatL,scr.box));
%     horizframeR=Screen('MakeTexture',scr.w,sc(horizframeMatR,scr.box));
%     vertframeR=Screen('MakeTexture',scr.w,sc(vertframeMatR,scr.box));
    
    %Screen('DrawTextures',scr.w,[horizframeL,horizframeR,horizframeL,horizframeR,vertframeL,vertframeR,vertframeL,vertframeR],[],[topFrameCoordL',topFrameCoordR',bottomFrameCoordL',bottomFrameCoordR',leftFrameL',leftFrameR',rightFrameL',rightFrameR'])
    
    %REPLACE HASHED FRAMES WITH AN HOMOGENOUS ONE
   % Screen('FrameRect', scr.w, sc(stim.fixL,scr.box),[scr.LcenterXLine-stim.horiz.width/2,scr.LcenterYLine-stim.vert.height/2,scr.LcenterXLine+stim.horiz.width/2,scr.LcenterYLine+stim.vert.height/2], stim.horiz.height)
   % Screen('FrameRect', scr.w, sc(stim.fixR,scr.box),[scr.RcenterXLine-stim.horiz.width/2,scr.RcenterYLine-stim.vert.height/2,scr.RcenterXLine+stim.horiz.width/2,scr.RcenterYLine+stim.vert.height/2], stim.horiz.height)
    % ------ Outside frames    
    stim.frameL = [scr.LcenterXLine-stim.frameWidth/2,scr.LcenterYLine-stim.frameHeight/2,scr.LcenterXLine+stim.frameWidth/2,scr.LcenterYLine+stim.frameHeight/2];
    stim.frameR = [scr.RcenterXLine-stim.frameWidth/2,scr.RcenterYLine-stim.frameHeight/2,scr.RcenterXLine+stim.frameWidth/2,scr.RcenterYLine+stim.frameHeight/2];
    Screen('FrameRect', scr.w, sc(stim.fixL,scr.box),stim.frameL, stim.frameLineWidth);
    Screen('FrameRect', scr.w, sc(stim.fixR,scr.box),stim.frameR, stim.frameLineWidth);
    %--------------------------------------------------------------------------
    %     flip(inputMode, scr.w);
    %     WaitSecs(2)
    
    
    %                 grayscaleImageMatrix=gaborTemplate(topframe,scr)
    %                 stim.frameWidth                 stim.frameLineWidth                 stim.frameHeight
    %        framesAutoFast(0,[stim.frameSize stim.frameSize 60 60],scr,stim.squareS,stim.frameLum,[],0.75,scr.centerY);
    
    %-----fixation
    drawDichFixation(scr,stim);    
    
   % maxi=round(stim.fixationLength+2*stim.fixationOffset+stim.fixationLineWidth/2);
    maxi=round(stim.fixationLength+2.*stim.fixationOffset+stim.fixationLineWidth);
    %centerRectMaskCoordL=[scr.LcenterXDot+7  scr.LcenterYLine-1-maxi (scr.LcenterXLine+stim.horiz.width/2+stim.vert.width/2)-30,scr.LcenterYLine+1+maxi];
    %centerRectMaskCoordR=[(scr.RcenterXLine-stim.vert.width/2-stim.horiz.width/2)+30  scr.RcenterYLine-1-maxi  scr.RcenterXDot-7  scr.RcenterYLine+1+maxi ];
    centerRectMaskCoordL=[scr.LcenterXLine,  scr.LcenterYLine-maxi, scr.LcenterXLine+maxi,scr.LcenterYLine+maxi];
    centerRectMaskCoordR=[scr.RcenterXLine-maxi,  scr.RcenterYLine-maxi, scr.RcenterXLine,scr.RcenterYLine+maxi ];

%     centerRectCoords=[scr.LcenterXDot+7,min((scr.LcenterYLine-stim.horiz.height/2-stim.vert.height/2)-50,scr.RcenterYLine-stim.horiz.height/2-stim.vert.height/2-50),...
%         scr.RcenterXDot-1,max((scr.RcenterYLine+stim.horiz.height/2+stim.vert.height/2)+50,scr.LcenterYLine+stim.horiz.height/2+stim.vert.height/2+50)];
    
%DRAW A MASK ON HALF THE CROSS TO CHECK COMPLEMENTARITY
    Screen('FillRect', scr.w, sc(scr.backgr,scr.box), centerRectMaskCoordL)
    Screen('FillRect', scr.w, sc(scr.backgr,scr.box), centerRectMaskCoordR)
    flip2(inputMode, scr.w);
    
%     %close texture to avoid lag
%     Screen('Close',horizframeL);
%     Screen('Close',vertframeL);
%     Screen('Close',horizframeR);
%     Screen('Close',vertframeR);
    
    %                 waitForKey(scr.keyboardNum,inputMode);
    %                 Screen('FillRect', scr.w, sc(scr.backgr,scr.box));
    %         %-------------------- WAIT ------------------------------------------
    
    
    %         %--------------------------------------------------------------------------
    %         %   SCREEN CAPTURE
    %         %--------------------------------------------------------------------------
    %             theFrame=[150 0 650 500];
    %             Screen('FrameRect', scr.w, 255, theFrame)
    %             flip(inputMode, scr.w, [], 1);
    %             %WaitSecs(1)
    %             %im=Screen('GetImage', scr.w, theFrame);
    %             %save('im2.mat','im')
    %
    
    %                     if displayMode==1
    %                          Screen('DrawDots', scr.w, [scr.LcenterXDot,scr.RcenterXDot;LcenterYDot,LcenterYDot], 1,sc(stim.noniusLum,scr.box));
    %
    %                           displayText(scr,sc(scr.fontColor,scr.box),[0,0,scr.res(3),200],['b:',num2str(block),'/t:',num2str(t),'/c:',num2str(cond),' /ofst: ', num2str(offset),' /ofp ', num2str(offsetPx), '/upRO:', num2str(upRightOffset),'/jit:',num2str(jitter),'/upF:',num2str(upFactor)]);
    %                     end
    % displaystereotext3(scr,sc(scr.fontColor,scr.box),expe.instrPosition,['Block ', num2str(expe.instrPosition)],1);
    
    %             [dummy onsetStim]=flip(inputMode, scr.w,onsetMask1+stim.mask1Duration/1000);
    %                      if displayMode==1; waitForKey(scr.keyboardNum,inputMode); end
    %             %waitForT(stim.itemDuration,inputMode);
    %             %ACTUALLY, instead of waiting, draw stuff and wait on next flip
    %             Screen('FillRect', scr.w, sc(scr.backgr,scr.box));
    
    %         %--------------------------------------------------------------------------
    %         %   DISPLAY MASK 2
    %         %--------------------------------------------------------------------------
    %              Screen('DrawTextures', scr.w, [text2,text1], [], [destrectL',destrectR']);
    %               [dummy offsetStim]=flip(inputMode, scr.w,onsetStim+stim.itemDuration/1000);
    %              %waitForT(stim.mask1Duration,inputMode);
    %              %ACTUALLY, instead of waiting, draw stuff and wait on next flip
    %              Screen('FillRect', scr.w, sc(scr.backgr,scr.box));
    
    
    %--------------------------------------------------------------------------
    %   GET RESPONSE
    %--------------------------------------------------------------------------
    % [dummy offsetMask2]=flip(inputMode, scr.w,offsetStim+stim.mask2Duration/1000);
    %[responseKey, RT]=getResponseKb(scr.keyboardNum,0,inputMode,allowR]);
    [responseKey, RT]=getResponseKb(scr.keyboardNum,0,inputMode,allowR,'robotModeDSTv1',0,1,1,1,1);
    
    if responseKey>0
        
        %--------------------------------------------------------------------------
        %  Keys
        %--------------------------------------------------------------------------
        % left, right, up, down control left eye position
        % 8,4,6,2 on padnum control right eye position
        % q and a are increasing and decreasing left eye contrast
        % w and s are increasing and decreasing right eye contrast
        % e and d are increasing and decreasing flickering frequency
        % Space validates the setting
        % Esc quits without saving
        
        % ------------- ALLOWED RESPONSES (find the codes in getResponseKb) -----%
        %       Response Code Table:
        %               0:  no keypress before time limit
        %               1:  left
        %               2:  right
        %               3:  space
        %               4:  escape
        %               5:  up
        %               6:  down
        %               12: numpad 2
        %               18: numpad 8
        %               14: numpad 4
        %               16: numpad 6
        %               20: a
        %               36: q
        %               42: w
        %               38: s
        %               24: e
        %               23: d
        
        % --- ESCAPE PRESS : escape the whole program ----%
        if responseKey==4
            disp('Voluntary Interruption')
%            warnings
            precautions(scr.w, 'off');
            return
        end
        
        % --- SPACE BAR PRESS : escape the calibration with parameters ----%
        if responseKey==3
            goFlag=0;
        end
        
        % --- MODIFICATION OF LEFT AND RIGHT EYE POSITION  ----%
        if responseKey==1 % LE goes left, RE goes right
            calib.leftLeftShift= calib.leftLeftShift-1;
            calib.rightLeftShift= calib.rightLeftShift+1;
        end
        
        if responseKey==2 % LE goes right, RE goes left
            calib.leftLeftShift= calib.leftLeftShift+1;
            calib.rightLeftShift= calib.rightLeftShift-1;
        end
        
        if responseKey==5 %LE goes up, right goes down
             calib.leftUpShift= calib.leftUpShift+1;
             calib.rightUpShift= calib.rightUpShift-1;
        end
        
        if responseKey==6 %LE goes down, right goes up
             calib.leftUpShift= calib.leftUpShift-1;
             calib.rightUpShift= calib.rightUpShift+1;
        end
        
        
        % --- MODIFICATION OF DOMINANT EYE CONTRAST ----%
        if expe.DE == 1 %LE dominant
            if responseKey==53
                 calib.leftContrNum= calib.leftContrNum-0.1;
            end

            if responseKey==54
                 calib.leftContrNum= calib.leftContrNum+0.1;
            end

        else %RE dominant
            if responseKey==53
                 calib.rightContrNum= calib.rightContrNum-0.1;
            end

            if responseKey==54
                 calib.rightContrNum= calib.rightContrNum+0.1;
            end
        end
    end
    
    % ---------------------------------------------------------
    %    set calibration coordinate limits 
    % ---------------------------------------------------------       
        
        if (scr.LcenterXLineIni - calib.leftLeftShift)-stim.horiz.width/2<0   % left OUTER boundary limit
            calib.leftLeftShift=calib.leftLeftShift-1;
        end
        
        if (scr.LcenterXLineIni - calib.leftLeftShift)+stim.horiz.width/2>scr.centerX% left inner
            calib.leftLeftShift=calib.leftLeftShift+1;
        end
        
        if (scr.RcenterXLineIni - calib.rightLeftShift)-stim.horiz.width/2<scr.centerX % right inner
            calib.rightLeftShift=calib.rightLeftShift-1;
        end
        
        if (scr.RcenterXLineIni - calib.rightLeftShift)+stim.horiz.width/2>scr.res(3) % right outer
            calib.rightLeftShift=calib.rightLeftShift+1;
        end
                
        if (scr.LcenterYLine-calib.leftUpShift)+stim.horiz.height/2-stim.vert.height/2-10<0  % left upper
            calib.leftUpShift=calib.leftUpShift-1;
        end
        
        if (scr.RcenterYLine-calib.rightUpShift)+stim.horiz.height/2-stim.vert.height/2-10<0 % right upper
            calib.rightUpShift=calib.rightUpShift-1;
        end
        
        if  (scr.LcenterYLine-calib.leftUpShift)+stim.horiz.height/2+stim.vert.height/2+10>scr.res(4)
            calib.leftUpShift=calib.leftUpShift+1;% Left lower
        end
        if (scr.RcenterYLine-calib.rightUpShift)+stim.horiz.height/2+stim.vert.height/2+10>scr.res(4) % right lower
            calib.rightUpShift=calib.rightUpShift+1;
        end

    
    %--------------------------------------------------------------------------
    %   DISPLAY MODE STUFF
    %--------------------------------------------------------------------------
    texts2Disp=sprintf('%5.0f %5.0f %5.0f %5.0f %5.1f %5.2f %5.1f %5.2f %5.3f %5.1f', [calib.leftLeftShift,calib.leftUpShift,calib.rightLeftShift,calib.rightUpShift,calib.leftContrNum,calib.leftContr,calib.rightContrNum,calib.rightContr,calib.leftContr./calib.rightContr, stim.LmaxL]);
    if displayMode==1
        displayText(scr,sc(colorText,scr.box),[scr.LcenterXLine-75-maxi,scr.LcenterYLine-1-maxi-2.*scr.fontSize,scr.res(3),200],texts2Disp);
        displayText(scr,sc(colorText,scr.box),[scr.RcenterXLine-75-maxi,scr.RcenterYLine-1-maxi-2.*scr.fontSize,scr.res(3),200],texts2Disp);
    end
end


%flip(inputMode, scr.w);

%            if displayMode==1
%                 Screen('FillRect', scr.w, sc(scr.backgr,scr.box));
%                 displayText(scr,sc(scr.fontColor,scr.box),[0,100,scr.res(3),200],['responseKey:',num2str(responseKey),'/resp: ',num2str(resp),'/RT:',num2str(RT)]);
%                 flip(inputMode, scr.w,[],1);
%                 waitForKey(scr.keyboardNum,inputMode);
%                 Screen('FillRect', scr.w, sc(scr.backgr,scr.box));
%                 flip(inputMode, scr.w,[],1);
%            end

%         %--------------------------------------------------------------------------
%         %  SAVE STUFF
%         %--------------------------------------------------------------------------
%          stuff2save=[block, nan, t, cond, nan, nan, currentValue, upRightOffset, responseKey, resp, RT, offsetStim-onsetStim, nan, nan jitter];

%         %--------------------------------------------------------------------------
%         %   INTER TRIAL
%         %--------------------------------------------------------------------------
%            %inter-trial is actually at the begistepIing of next trial to allow pre-loading of textures in the meantime.
%            %to be able to do that, we have to start counting time
%            %from now on:
%            beginInterTrial=GetSecs;

%         %------ Progression bar for robotMode ----%
%             if inputMode==2
%                 Screen('FillRect',scr.w, sc([scr.fontColor,0,0],scr.box),[0 0 scr.res(3)*t/goalCounter 10]);
%                 Screen('Flip',scr.w);
%             end
end
