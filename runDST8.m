function runDST8
%------------------------------------------------------------------------

%------------------------------------------------------------------------
% A wrapper function to launch all parts of DST v8, providing the correct parameters
%=======================================================================


       param.inputMode=1;
       param.quickMode=2;
       param.displayMode=2;
       param.polarity = 4;
 
       [pathExp,~]=fileparts(mfilename('fullpath'));
       addpath(fullfile(pathExp,'fonctions_DST'))
       addpath(fullfile(pathExp,'screen'))
       
       [param.scr, param.box]=screen_parameters;
       DST8(param);
 
