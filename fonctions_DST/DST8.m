function DST8(param)
%------------------------------------------------------------------------
%   This code (2019) is a simple modification of previous version.
%   The differences are:
%       - it gives a better option to enter the screen parameters through a separate file to edit manually 
%------------------------------------------------------------------------%------------------------------------------------------------------------

%----------------------------------------------------------------------------------------------------
% Running comments: run this function to calibrate screen contrast / position and check the resulting fusion
%----------------------------------------------------------------------------------------------------
% VRS - Virtual Reality Stereo project
%-----------------------------------------------------------------------
%
%================== Fusion Test ====================================
%   Amblyopic participants have to go through a fusion test to be sure that:
%       -participants can fuse coarsly (anti-suppression)
%       -participants can fuse finely (absence of diplopia)
%
%   This function does:
%       - initialization of a manual calibration adjusting each eye contrast, and frame position and the alternating flicker (default: none)
%       - check anti-suppression and absence of diplopia (fusions) with a simple quick test (approx. 30 trials)
%
%=======================================================================
% Task: See separate instructions
%------------------------------------------------------------------------

try
    clc
    [pathExp,~]=fileparts(fileparts(mfilename('fullpath')));
    rootpath=fileparts(pathExp);
    disp(' ------------    DST v8  ------------------')
    disp(dateTime)
    dispi('Started from: ',pathExp)
    diary(fullfile(pathExp,'log',[sprintf('%02.f_',fix(clock)),'DST.txt']));
    diary ON
    disp(['Checking that experimental path exists: ', pathExp])
    if exist(pathExp, 'dir');        cd(pathExp);    else        error('runDST: missing path');    end
    disp('Moving path on top of path search list')
    path(genpath(pathExp), path);
    disp(['Adding fonctions_MATLAB from Berkeley Drive on top too: ',genpath(fullfile(rootpath,'fonctions_MATLAB'))])
    path(genpath(fullfile(rootpath,'fonctions_MATLAB')), path);
      
    if ~exist('param', 'var')
        polarity = 4; %1 : standard with grey background, 2: white on black background, 3: black on white background
        %4: half half
    end
        
    %==========================================================================
    %                           QUICK PARAMETERS
    %==========================================================================
if ~exist('param', 'var')   
    %===================== INPUT MODE ==============================
    %1: User  ; 2: Robot
    %The robot mode allows to test the experiment with no user awaitings
    %or long graphical outputs, just to test for obvious bugs
    inputMode=1;
    %==================== QUICK MODE ==============================
    %1: ON  ; 2: OFF
    %The quick mode allows to skip all the input part at the beginning of
    %the experiment to test faster for what the experiment is.
    quickMode=1;
    %==================== DISPLAY MODE ==============================
    %1: ON  ; 2: OFF
    %In Display mode, some chosen variables are displayed on the screen
    displayMode=1;
    %===============================================================
else
    disp('Use wrapper parameters');
    inputMode=param.inputMode;
    quickMode=param.quickMode;
    displayMode=param.displayMode;
    polarity = param.polarity;
end

cd([pathExp,filesep,'dataFiles'])

    %----- mode related stuff ---%
    if quickMode==2
        nameDST = safeInputName(fullfile(pathExp,'dataFiles'));
        DE=str2double(input('Non-amblyopic Eye (1 for Left; 2 for Right):  ', 's'));
       input('Press a key to start')
    else
        nameDST='default';
        DE = 2;
    end
    
    
    %=========  STARTERS =================================================== %
    %Initialize and load experiment settings (window and stimulus)
        
    %first check is file exists for that name
    file= [cd,filesep, nameDST,'.mat'];
    alreadyStarted=exist(file,'file')==2;
    
    %if file exist but its default, delete and start afresh
    if quickMode==1 && alreadyStarted==1; delete(file); delete([cd,filesep, nameDST,'.txt']); alreadyStarted=0; end 

    if alreadyStarted==0 %intialize
       
        %--------------------------------------------------------------------------
        %LOAD EXPERIMENTAL PARAMETERS FROM A SEPARATE FILE
        %--------------------------------------------------------------------------
        [expe,scr,stim,sounds]=globalParametersDST8(param.scr,param.box);
        if exist('parameters','var')
            %special parameters to change after loading
            disp parameters
        end
        file= [cd,filesep, nameDST,'.mat'];

        
    else
       %if the file exists, just load it, but not if robotmode / quicmode
       

           disp('Name exists: load previous data and parameters')
            load([nameDST,'.mat'])
            Screen('Preference', 'SkipSyncTests', 0);
        scr.w=Screen('OpenWindow',scr.screenNumber, sc(scr.backgr,scr.box), [], 32, 2);
        precautions(scr.w, 'on');
    end
       
    %----- ROBOT MODE ------%
    %when in robot mode, make all timings very short
    if inputMode==2
        stim.duration                  = 0.001;
    end
    
    %initialisation of variables
    abort = 1;
    expe.DE = DE;
    if expe.DE == 1
        calib.leftContr=stim.frameContrast;
        calib.rightContr=stim.frameContrast;
    else
        calib.leftContr=stim.frameContrast;
        calib.rightContr=stim.frameContrast;
    end
    calib.leftUpShift=0;
    calib.rightUpShift=0;
    calib.leftLeftShift=0;
    calib.rightLeftShift=0;
    calib.flickering=0;
    stim.polarity =  polarity;
     
    switch polarity 
        case {2}
            scr.backgr = stim.minLum;
        case {3}
            scr.backgr = stim.maxLum;
    end
    expe.startTime=GetSecs;
    
    %--------------------- INITIAL STEREOSCOPE MIRROR CALIBRATION DISPLAY(continues after keypress) --------------------------------
    displayStereoscopeCalibration(stim,scr,inputMode);
    waitForKey(scr.keyboardNum,inputMode);
    %-----------------------------------------------------  
    
    while abort == 1
        
        % ===  MANUAL CALIBRATION FOR CONTRAST AND POSITION   === %
        if inputMode==1
            WaitSecs(1);
            [calib,stim]=calibration(expe,scr,stim,sounds, inputMode, displayMode,calib);
        else %except when robot mode
        calib.leftContr=0.96;   calib.rightContr=0.96;  calib.leftUpShift=0;  calib.rightUpShift=0;  calib.leftLeftShift=0;  calib.rightLeftShift=0;  calib.flickering=0;
        end
        
        % ====== TESTING ================%
        [savedTrials,abort]=fusionTest(expe,scr,stim,sounds, inputMode, displayMode, calib);
    end
    
   
%later, most codes will load directly the following variables 
    leftContr = calib.leftContr;   rightContr = calib.rightContr;  leftUpShift = calib.leftUpShift;
    rightUpShift = calib.rightUpShift;  leftLeftShift = calib.leftLeftShift;  rightLeftShift = calib.rightLeftShift;  
    flickering = calib.flickering; LcenterX = scr.LcenterX; RcenterX = scr.RcenterX;  centerY = scr.centerY;

    % ---- QUIT ---- %
    precautions(scr.w, 'off');
    
    %%------------------ Analyse ------------------%
    
    bino=savedTrials(savedTrials(:,1)==1,:);
    leftEye=savedTrials(savedTrials(:,1)==2,:);
    rightEye=savedTrials(savedTrials(:,1)==3,:);
    
    diff=[savedTrials(:,1), savedTrials(:,3)-savedTrials(:,2)]; %savedTrials structure is: binoType, nbDots, response
    %[1: binocular, 2: left eye only; 3: right eye only]
    binoDiff=diff(diff(:,1)==1,:) ;
    
    figure(1);
    subplot(3,1,1);
    TextTable.fig1.subfig1.en={'Diplopia Error','n','Error'};
    fontSize=14;
    hist(binoDiff(:,2)); %distributions of the nb of dots (presented)
    legendAxis(TextTable,1,1,'en',fontSize)  ;
    
    % ============= DIPLOPIA =================%
    subplot(3,1,2);
    TextTable.fig1.subfig2.en={'Diplopia Value','n','Ratio Perceived Nb / True Nb'};
    ratio=bino(:,3)./bino(:,2); %if this ratio is 2, it means diplopia
    ratio(isfinite(ratio)==0)=[];
    diplopiaScore=100*mean(ratio)-100;
    disp(['Diplopia score: ',num2str(diplopiaScore),'%']);
    hist(ratio);
    legendAxis(TextTable,1,2,'en',fontSize)  ;
    
   
    %---------D' Scores
     
     nbHitL=sum(leftEye(:,2)==1 & leftEye(:,3)==1);
     nbHitR=sum((rightEye(:,2)==1 & rightEye(:,3)==1));
     % nbHit=nbHitL+nbHitR;
      
    nbFAL=sum(leftEye(:,2)==0 & leftEye(:,3)>0);
    nbFAR=sum((rightEye(:,2)==0 & rightEye(:,3)>0));
    % nbFA= nbFAL+nbFAR;
    
    nbMissL=sum(leftEye(:,2)>0 & leftEye(:,3)==0);
    nbMissR=sum((rightEye(:,2)>0 & rightEye(:,3)==0));
    % nbMiss=nbMissL+nbMissR;
     
    nbCRL=sum(leftEye(:,2)==0 & leftEye(:,3)==0);
    nbCRR=sum(rightEye(:,2)==0 & rightEye(:,3)==0);
    % nbCR=  nbCRL+nbCRR;
   
    
    dprL=dprime(nbHitL,nbFAL,nbMissL,nbCRL);
    dprR=dprime(nbHitR,nbFAR,nbMissR,nbCRR);
   %  dpr=dprime(nbHit,nbFA,nbMiss,nbCR);
    
   
  
    %-----PLOT DPRIME
    subplot(3,1,3);
    bar([dprL, dprR]) ; %error distribution when presenting only right eye
    TextTable.fig2.subfig1.en={'Suppression','D prime score', ' '};
    xlim([0 3]);
    set(gca,'XTickLabel',{'Left Eye','Right Eye'});
    legendAxis(TextTable,2,1,'en',fontSize)  ;
    disp(['Dprime Score Left Eye: ' , num2str(dprL)]); disp(['Dprime Score Right Eye: ' , num2str(dprR)]);
    expe.endTime=GetSecs;
    duration = (expe.endTime-expe.startTime)/60;
    disp(['Duration (min): ',num2str(duration)]);
   
    
    %--------------------------------------------------------------------------
    %   SAVE AND QUIT
    %--------------------------------------------------------------------------

        clear quickMode inputMode displayMode
        disp(['Saving data to: ', nameDST, '.mat'])
        save(fullfile(pathExp,'dataFiles',[nameDST, '.mat']))
        saveAll(fullfile(pathExp,'dataFiles',[nameDST, '.mat']),fullfile(pathExp,'dataFiles',[nameDST, '.txt']))
        dispDST

    
    %===== QUIT =====%
    warnings
    changeResolution(scr.screenNumber, scr.oldResolution.width, scr.oldResolution.height, scr.oldResolution.hz);
    diary OFF
    
catch err   %===== DEBUGING =====%
    disp(err)
    try
        save(fullfile(pathExp,'log',[nameDST,'-crashlog']))
        saveAll(fullfile(pathExp,'log',[nameDST,'-crashlog.mat']),fullfile(pathExp,'log',[nameDST,'-crashlog.txt']))
        warnings
        diary OFF
        
        if exist('scr','var');     changeResolution(scr.screenNumber, scr.oldResolution.width, scr.oldResolution.height, scr.oldResolution.hz);precautions(scr.w, 'off');  end
         rethrow(err);
    catch err2
        disp(err2)
        rethrow(err2);
    end

end
end










