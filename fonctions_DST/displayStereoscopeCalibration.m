function displayStereoscopeCalibration(stim,scr,inputMode)
    
    %LcenterXLine= scr.LcenterXLine ;
    %RcenterXLine= scr.RcenterXLine ;
    %LcenterYLine = scr.centerYLine ;
    %RcenterYLine = scr.centerYLine;
    
   % if stim.polarity == 1; init = scr.backgr; scr.backgr = scr.bg; end
%     horizframeMatL=ultimateGabor(scr.VA2pxConstant, stim.horiz);
%     vertframeMatL=ultimateGabor(scr.VA2pxConstant, stim.vert);
%     horizframeMatR=ultimateGabor(scr.VA2pxConstant, stim.horiz);
%     vertframeMatR=ultimateGabor(scr.VA2pxConstant, stim.vert);
  %  if stim.polarity == 1; scr.backgr = init; end
    
    %topFrameCoordL=[LcenterXLine-stim.horiz.width/2,LcenterYLine-stim.horiz.height/2-stim.vert.height/2,LcenterXLine+stim.horiz.width/2,LcenterYLine+stim.horiz.height/2-stim.vert.height/2];
    %topFrameCoordR=[RcenterXLine-stim.horiz.width/2,RcenterYLine-stim.horiz.height/2-stim.vert.height/2,RcenterXLine+stim.horiz.width/2,RcenterYLine+stim.horiz.height/2-stim.vert.height/2];
    %bottomFrameCoordL=[LcenterXLine-stim.horiz.width/2,LcenterYLine-stim.horiz.height/2+stim.vert.height/2,LcenterXLine+stim.horiz.width/2,LcenterYLine+stim.horiz.height/2+stim.vert.height/2];
    %bottomFrameCoordR=[RcenterXLine-stim.horiz.width/2,RcenterYLine-stim.horiz.height/2+stim.vert.height/2,RcenterXLine+stim.horiz.width/2,RcenterYLine+stim.horiz.height/2+stim.vert.height/2];
    %leftFrameL=[LcenterXLine-stim.vert.width/2-stim.horiz.width/2,LcenterYLine-stim.vert.height/2-stim.horiz.height/2,LcenterXLine-stim.horiz.width/2+stim.vert.width/2,LcenterYLine+stim.vert.height/2+stim.horiz.height/2];
    %leftFrameR=[RcenterXLine-stim.vert.width/2-stim.horiz.width/2,RcenterYLine-stim.vert.height/2-stim.horiz.height/2,RcenterXLine-stim.horiz.width/2+stim.vert.width/2,RcenterYLine+stim.vert.height/2+stim.horiz.height/2];
    %rightFrameL=[LcenterXLine-stim.vert.width/2+stim.horiz.width/2,LcenterYLine-stim.vert.height/2-stim.horiz.height/2,LcenterXLine+stim.horiz.width/2+stim.vert.width/2,LcenterYLine+stim.vert.height/2+stim.horiz.height/2];
    %rightFrameR=[RcenterXLine-stim.vert.width/2+stim.horiz.width/2,RcenterYLine-stim.vert.height/2-stim.horiz.height/2,RcenterXLine+stim.horiz.width/2+stim.vert.width/2,RcenterYLine+stim.vert.height/2+stim.horiz.height/2];
    
    
    red = [200 0 0]; green = [0 200 0];
    
%     horizframeL=Screen('MakeTexture',scr.w,sc(horizframeMatL,scr.box));
%     vertframeL=Screen('MakeTexture',scr.w,sc(vertframeMatL,scr.box));
%     horizframeR=Screen('MakeTexture',scr.w,sc(horizframeMatR,scr.box));
%     vertframeR=Screen('MakeTexture',scr.w,sc(vertframeMatR,scr.box));

    [~,stim.fixL]=contrSym2Lum(stim.frameContrast,scr.backgr); %white and black, left eye
    [~,stim.fixR]=contrSym2Lum(stim.frameContrast,scr.backgr); %white and black, right eye
    Screen('FillRect',scr.w, sc(scr.backgr,scr.box));
    
    % ------ Outside frames    
    Screen('FrameRect', scr.w, sc(stim.fixL,scr.box),stim.frameL, stim.frameLineWidth);
    Screen('FrameRect', scr.w, sc(stim.fixR,scr.box),stim.frameR, stim.frameLineWidth);
            
    %Screen('DrawTextures',scr.w,[horizframeL,horizframeR,horizframeL,horizframeR,vertframeL,vertframeR,vertframeL,vertframeR],[],[topFrameCoordL',topFrameCoordR',bottomFrameCoordL',bottomFrameCoordR',leftFrameL',leftFrameR',rightFrameL',rightFrameR'])
     Screen('DrawLines',scr.w, [scr.LcenterXLine,scr.LcenterXLine,scr.RcenterXLine,scr.RcenterXLine;0,scr.res(4),0,scr.res(4)],...
        stim.fixationDotSize/4, ([red',red',green',green']));
    flip2(inputMode, scr.w);
