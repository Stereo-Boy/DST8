function [expe,scr,stim,sounds]=globalParametersDST8(scr,boxi)
%======================================================================
%  Goal: control panel for the expriment parameters
%======================================================================
% STaM Project [Stereo-Training and MRI]
% Apr 2014 - Berkeley
%-----------------------------------------------------------------------

%set the randomness random
%rng('default') %does not work on experimetn computer
rand('twister', sum(100*clock)); %rng('shuffle');

%======================================================================
%              WINDOW-SCREEN PARAMETERS
%======================================================================

Screen('Preference', 'SkipSyncTests', 0); %changed from 2
screens=Screen('Screens');
scr.screenNumber=max(screens);
scr.box=boxi;

        %check that we have the appropriate resolution
            scr.oldResolution=Screen('Resolution',scr.screenNumber);
            if scr.oldResolution.width==scr.goalWidthRes && scr.oldResolution.height==scr.goalHeightRes && scr.oldResolution.hz==scr.goalRefreshRate
                disp('Resolution and refresh are correct')
            else
                 changeResolution(scr.screenNumber, scr.goalWidthRes, scr.goalHeightRes, scr.goalRefreshRate);
            end
            scr.res=Screen('Rect', scr.screenNumber); %screen size in pixel, format: [0 0 maxHoriz maxVert]
%check if vertical and horizontal pixel sizes are the same
scr.ppBymm= scr.res(3)/scr.W;
if abs((scr.res(3)/scr.W)-(scr.res(4)/scr.H))>0.05; warning('Ratio error >5%: change the screen resolution to have equal pixel sizes.');end
scr.VA2pxConstant=scr.ppBymm *10*VA2cm(1,scr.distFromScreen); %constant by which we multiply a value in VA to get a value in px
scr.backgr=40; %in cd/m2
scr.bg = scr.backgr; %copy
scr.fontColor=0;
scr.keyboardNum=-1;
scr.w=Screen('OpenWindow',scr.screenNumber, sc(scr.backgr,scr.box), [], 32, 2);
scr.fontSize  = 10;
Screen('BlendFunction', scr.w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

%now defines centers of screen and centers of stereo screens
%Caution has to be taken because the screen origin for DrawLine and
%DrawDots are different, and are also dependent on the screen
%On a viewPixx, screen originates at [1,0] for DrawLine and [0,1]
%for DrawDots
scr.centerX = scr.res(3)/2;
scr.centerY = scr.res(4)/2;
scr.stereoDeviation = scr.ppBymm.*scr.frameSep; %nb of px necessary to add from screen center in order to put a stim a zero disp

scr.LcenterX=round(scr.centerX-scr.stereoDeviation);
scr.RcenterX=round(scr.centerX+scr.stereoDeviation);
scr.centerY=round(scr.centerY);
scr.midPt=scr.centerX;

%Centers for Drawline
scr.LcenterXLine=ceil(scr.centerX-scr.stereoDeviation); %stereo position of left eye center
scr.RcenterXLine=ceil(scr.centerX+scr.stereoDeviation); %stereo position of right eye center
scr.centerYLine=ceil(scr.centerY); %stereo position of left eye center
%Centers for Drawdots
scr.LcenterXDot=ceil(scr.centerX-scr.stereoDeviation)-1; %stereo position of left eye center
scr.RcenterXDot=ceil(scr.centerX+scr.stereoDeviation)-1; %stereo position of right eye center
scr.centerYDot=ceil(scr.centerY)+1; %stereo position of left eye center
%--------------------------------------------------------------------------

%======================================================================
%              STIMULUS PARAMETERS
%======================================================================

%Fixation
stim.fixationLengthMin= 30; % half size in arcmin
stim.fixationLineWidthMin=12; %in arcmin  8 CHANGE HERE
stim.fixationOffsetMin= 10; %offset between central fixation and nonius in arcmin
stim.fixationDotSizeMin=12; %in arcmin

%Outer frames in fusion task (pheripheric frames)
stim.outFusFrameWidthVA=1.9; %8
stim.outFusFrameHeightVA=4; %11
stim.outFusFrameEccVA=0.9;
    
%Outside frame properties (outer box)
stim.frameLineWidthVA=0.2; %line width of the frames in VA
stim.frameWidthVA=7.1; %witdth of the outside frame in deg
stim.frameHeightVA=8; %in deg  
stim.frameContrast=0.96;
stim.framePhase=pi;

% if scr.distFromScreen==150
%     stim.frameWidthVA=7;
%     stim.frameHeightVA=7;
% end
    
stim.horiz.widthVA=stim.frameWidthVA; stim.horiz.heightVA=stim.frameLineWidthVA; stim.horiz.averageL=scr.backgr;
stim.horiz.contrast=stim.frameContrast; stim.horiz.tilt=90;  stim.horiz.spatialFrequencyDeg=0.4;
stim.horiz.phase=stim.framePhase; stim.horiz.FWHM = 100;
stim.horiz.discrete=1; % set to make horiz frames with stripes, not gabor. JS 8/1/14

stim.vert.widthVA=stim.frameLineWidthVA; stim.vert.heightVA=stim.frameHeightVA; stim.vert.averageL=scr.backgr;
stim.vert.contrast=stim.frameContrast; stim.vert.tilt=0;  stim.vert.spatialFrequencyDeg=0.4;
stim.vert.phase=stim.framePhase; stim.vert.FWHM = 100;
stim.vert.discrete=1;% set to make horiz frames with stripes, not gabor. JS 8/1/14
stim.maxLum = 2*scr.backgr; %max visible luminance on the display (white) - not used for polarity 4
stim.minLum = 0; %used to determine ink for writing too, among others

%Dots and circles in fusion test
stim.circleSizeVA=0.6;       %diameter in degVA
stim.circleLineWidthMin=4; %line width for circles, in arcmin
stim.dotSizeVA=0.25; %diameter in degVA
%stim.apparentSizeVA = 0.20; % = gaussian dot FWHM in va
%stim.dotSizeRangeVA= [0.15 0.4]; %TO DO - dot sizes are uniformly picked between min and max sizes in deg VA
%stim.dotDensity= 25; % in %
%stim.coherence = 0; %in %

%Conversions in pixels
stim.fixationLength=round(convertVA2px(stim.fixationLengthMin/60));
stim.fixationLineWidth=round(convertVA2px(stim.fixationLineWidthMin/60));
stim.fixationOffset=round(convertVA2px(stim.fixationOffsetMin/60));
stim.fixationDotSize=round(convertVA2px(stim.fixationDotSizeMin/60));
stim.horiz.width=round(convertVA2px(stim.horiz.widthVA));
stim.horiz.height=round(convertVA2px(stim.horiz.heightVA));
stim.vert.width= round(convertVA2px(stim.vert.widthVA));
stim.vert.height= round(convertVA2px(stim.vert.heightVA));
stim.frameLineWidth = round(convertVA2px(stim.frameLineWidthVA));
stim.circleSize= round(convertVA2px(stim.circleSizeVA));
stim.circleLineWidth= round(convertVA2px(stim.circleLineWidthMin/60));
stim.outFusFrameWidth=round(convertVA2px(stim.outFusFrameWidthVA));
stim.outFusFrameHeight=round(convertVA2px(stim.outFusFrameHeightVA));
stim.outFusFrameEcc=round(convertVA2px(stim.outFusFrameEccVA));
%stim.dotSize=round(convertVA2px(stim.dotSizeVA));
if mod(stim.outFusFrameWidth,2)~=0; disp('stim.outFusFrameWidth should be a multiple of 2: we add 1 to it.');  stim.outFusFrameWidth = stim.outFusFrameWidth+1; end

% if stim.dotSize>20
%     dispi('Current dot size in px: ',stim.dotSize)
%     disp('dotSize cannot be above 20 because most hardwares do not support this')
%     precautions(scr.w, 'off'); 
%     error('Aborting (see message above): please remove that line to try anyway or decrease screen resolution')
% end

if scr.viewpixx==1
%     %SPECIAL VIEWPIXX
    if scr.box==17
        Datapixx('Open');
        Datapixx('EnableVideoScanningBacklight');
        Datapixx('RegWrRd');
        status = Datapixx('GetVideoStatus');
        fprintf('Scanning Backling mode on = %d\n', status.scanningBacklight);
        Datapixx('Close');
    end
end

%--------------------------------------------------------------------------
% TIMING (All times are in MILLISECONDS)
%--------------------------------------------------------------------------
% stim.duration                  = 200;
% stim.itemDuration                  = 5000; 
% stim.interTrial                    = 200;   
% stim.minimalDuration                = 200; 

%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%         sounds PARAMETERS
%--------------------------------------------------------------------------
duration=0.2;
freq1=1000;
freq2=500;
freq3 = 2000;
        sounds.success=soundDefine(duration,freq1);
        sounds.fail=soundDefine(duration,freq2);
        sounds.outFixation = soundDefine(duration,freq3);

%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%         EXPERIENCE PARAMETERS
%--------------------------------------------------------------------------
expe.name='DST8';
expe.time=[]; %durations of the sessions in min
expe.vergenceTime=[]; %duration of vergence test
expe.date={}; %dates of the sessions
expe.breaks=[]; %for each break, block, trial and duration of the break in sec
expe.breakTime=10;%time after which there is a small break, in min
expe.instrPosition=[0,300,400,1100];
expe.escapeTimeLimit=10; %(min) nb of min after which escape key is deactivated

%fusion Test properties
expe.fusionTestTrialNb1=10;  %nb of trials in diplopia test
expe.fusionTestTrialNb2=15; %nb of trials in each condition of suppression test
expe.fusionTestcircleNb1=3; %nb of circles in the fusion test with dots on each side
% ============================================
%           Conversions in pixels
% ============================================
% stim.fixationLength=round(convertVA2px(stim.fixationLengthMin/60));
% stim.fixationLineWidth=round(convertVA2px(stim.fixationLineWidthMin/60));
% stim.fixationOffset=round(convertVA2px(stim.fixationOffsetMin/60));
% stim.fixationDotSize=round(convertVA2px(stim.fixationDotSizeMin/60));
% stim.horiz.width=round(convertVA2px(stim.horiz.widthVA));
% stim.horiz.height=round(convertVA2px(stim.horiz.heightVA));
% stim.vert.width= round(convertVA2px(stim.vert.widthVA));
% stim.vert.height= round(convertVA2px(stim.vert.heightVA));
% stim.frameLineWidth = round(convertVA2px(stim.frameLineWidthVA));
% stim.outFusFrameWidth=round(convertVA2px(stim.outFusFrameWidthVA));
% stim.outFusFrameHeight=round(convertVA2px(stim.outFusFrameHeightVA));
% stim.outFusFrameEcc=round(convertVA2px(stim.outFusFrameEccVA));
% stim.dotSizeRange=round(convertVA2px(stim.dotSizeRangeVA));
% stim.apparentSize = stim.apparentSizeVA.*scr.VA2pxConstant;

expe.breaktime.fr=strcat('Vous pouvez prendre une courte pause. Appuyez sur une touche pour continuer.');
expe.breaktime.en=strcat('You can take a short break. Press a key to continue.');
expe.thx.fr='===========  MERCI  ===========';
expe.thx.en='===========  THANK YOU  ===========';
        disp(expe)
        disp(scr)
        disp(stim)
        disp(sounds)
%--------------------------------------------------------------------------
precautions(scr.w, 'on');

    function px=convertVA2px(VA)
        px=round(scr.ppBymm *10*VA2cm(VA,scr.distFromScreen));
        %correct for when subpixel value is obtained
    end
end
