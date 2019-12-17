function DST2PD(filename)

%convert the DST results in prism diopter deviations
load(filename);
disp(['Loaded ', filename])
disp('raw values')
calib
LeftUpPd=2*(scr.distFromScreen/100)*calib.leftUpShift/(10*scr.ppBymm); %adds left and right shits together(assumes they are equal and they should be)
disp(['Left base down prism should be: ', num2str(LeftUpPd), ' PD'])
leftLeftPD=2*(scr.distFromScreen/100)*calib.leftLeftShift/(10*scr.ppBymm);
disp(['Left base left in prism should be: ', num2str(leftLeftPD),' PD'])