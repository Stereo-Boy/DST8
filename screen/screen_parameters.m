function [scr, box]=screen_parameters
% You need to edit this function with your screen parameters


scr.W = 540;                % screen width in mm           
scr.H = 320;                % screen heigth in mm
scr.frameSep = 105;         % Best is to use the distance between the inner and outer stereoscope mirrors in mm
                            % but if the frames bump into each other, it could be easily increased without any problem  
scr.distFromScreen = 150;   % distance to the screen in cm (should be 150 cm) 
scr.goalWidthRes = 1920;    % appropriate resolution (width in px) 
scr.goalHeightRes = 1080;   % appropriate resolution (height in px) 
scr.goalRefreshRate = 60;  % appropriate refresh rate
box= [0.00000033, 3.4275];      % gamma parameters for screen luminance calibration;  
                            % Function shape is: output(0-255) = (luminance./box(1)).^(1/box(2));
scr.viewpixx = 0;           % if this is a viewpixx screen (1) or not (0)