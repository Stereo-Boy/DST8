

% Convert the DST results in prism diopter deviations and display contrasts 
% It leaves to you the burden of loading the calibration values from the right DST file (all interesting info should be in 
% the calib structure

if exist('calib','var')==0; disp('No calib structure found in workspace - please first load the appropriate DST file'); end
disp('We work with current workspace structure calib')
dispi('It corresponds to the DST file called: ',nameDST)
LeftUpPd=2*(scr.distFromScreen/100)*calib.leftUpShift/(10*scr.ppBymm); %adds left and right shits together(assumes they are equal and they should be)
disp(['Left base down prism should be: ', num2str(LeftUpPd), ' PD'])
leftLeftPD=2*(scr.distFromScreen/100)*calib.leftLeftShift/(10*scr.ppBymm);
disp(['Left base left in prism should be: ', num2str(leftLeftPD),' PD'])
dispi(['Left eye contrast: ', num2str(calib.leftContr.*100),'%'])
dispi(['Right eye contrast: ', num2str(calib.rightContr.*100),'%'])
