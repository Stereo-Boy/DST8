function displayStereoscopeCalibration(stim,scr,inputMode)
    
    LcenterXLine= scr.LcenterXLine ;
    RcenterXLine= scr.RcenterXLine ;
    LcenterYLine = scr.centerYLine ;
    RcenterYLine = scr.centerYLine;
    
   % if stim.polarity == 1; init = scr.backgr; scr.backgr = scr.bg; end
    horizframeMatL=ultimateGabor(scr.VA2pxConstant, stim.horiz);
    vertframeMatL=ultimateGabor(scr.VA2pxConstant, stim.vert);
    horizframeMatR=ultimateGabor(scr.VA2pxConstant, stim.horiz);
    vertframeMatR=ultimateGabor(scr.VA2pxConstant, stim.vert);
  %  if stim.polarity == 1; scr.backgr = init; end
    
    topFrameCoordL=[LcenterXLine-stim.horiz.width/2,LcenterYLine-stim.horiz.height/2-stim.vert.height/2,LcenterXLine+stim.horiz.width/2,LcenterYLine+stim.horiz.height/2-stim.vert.height/2];
    topFrameCoordR=[RcenterXLine-stim.horiz.width/2,RcenterYLine-stim.horiz.height/2-stim.vert.height/2,RcenterXLine+stim.horiz.width/2,RcenterYLine+stim.horiz.height/2-stim.vert.height/2];
    bottomFrameCoordL=[LcenterXLine-stim.horiz.width/2,LcenterYLine-stim.horiz.height/2+stim.vert.height/2,LcenterXLine+stim.horiz.width/2,LcenterYLine+stim.horiz.height/2+stim.vert.height/2];
    bottomFrameCoordR=[RcenterXLine-stim.horiz.width/2,RcenterYLine-stim.horiz.height/2+stim.vert.height/2,RcenterXLine+stim.horiz.width/2,RcenterYLine+stim.horiz.height/2+stim.vert.height/2];
    leftFrameL=[LcenterXLine-stim.vert.width/2-stim.horiz.width/2,LcenterYLine-stim.vert.height/2-stim.horiz.height/2,LcenterXLine-stim.horiz.width/2+stim.vert.width/2,LcenterYLine+stim.vert.height/2+stim.horiz.height/2];
    leftFrameR=[RcenterXLine-stim.vert.width/2-stim.horiz.width/2,RcenterYLine-stim.vert.height/2-stim.horiz.height/2,RcenterXLine-stim.horiz.width/2+stim.vert.width/2,RcenterYLine+stim.vert.height/2+stim.horiz.height/2];
    rightFrameL=[LcenterXLine-stim.vert.width/2+stim.horiz.width/2,LcenterYLine-stim.vert.height/2-stim.horiz.height/2,LcenterXLine+stim.horiz.width/2+stim.vert.width/2,LcenterYLine+stim.vert.height/2+stim.horiz.height/2];
    rightFrameR=[RcenterXLine-stim.vert.width/2+stim.horiz.width/2,RcenterYLine-stim.vert.height/2-stim.horiz.height/2,RcenterXLine+stim.horiz.width/2+stim.vert.width/2,RcenterYLine+stim.vert.height/2+stim.horiz.height/2];
    

    red = [20 0 0]; green = [0 20 0];
    
    horizframeL=Screen('MakeTexture',scr.w,sc(horizframeMatL,scr.box));
    vertframeL=Screen('MakeTexture',scr.w,sc(vertframeMatL,scr.box));
    horizframeR=Screen('MakeTexture',scr.w,sc(horizframeMatR,scr.box));
    vertframeR=Screen('MakeTexture',scr.w,sc(vertframeMatR,scr.box));
    
    Screen('FillRect',scr.w, sc(scr.backgr,scr.box));
    
    Screen('DrawTextures',scr.w,[horizframeL,horizframeR,horizframeL,horizframeR,vertframeL,vertframeR,vertframeL,vertframeR],[],[topFrameCoordL',topFrameCoordR',bottomFrameCoordL',bottomFrameCoordR',leftFrameL',leftFrameR',rightFrameL',rightFrameR'])
     Screen('DrawLines',scr.w, [LcenterXLine,LcenterXLine,RcenterXLine,RcenterXLine;0,scr.res(4),0,scr.res(4)],...
        stim.fixationDotSize/4, sc([red',red',green',green']));
    flip2(inputMode, scr.w);
