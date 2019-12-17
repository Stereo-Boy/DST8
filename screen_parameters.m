function [scr, box]=screen_parameters
% You need to edit this function with your screen parameters


scr.W = 485;                % screen width in mm           
scr.H = 300;                % screen heigth in mm
scr.frameSep = 105;         % distance between the inner and outer stereoscope mirrors in mm
scr.distFromScreen = 150;   % distance to the screen in cm (should be 150 cm) 
scr.goalWidthRes = 1920;    % appropriate resolution (width in px) 
scr.goalHeightRes = 1200;   % appropriate resolution (height in px) 
scr.goalRefreshRate = 60;  % appropriate refresh rate
box= [0.00000033, 3.4275];      % gamma parameters for screen luminance calibration;  
                            % Function shape is: output(0-255) = (luminance./box(1)).^(1/box(2));
scr.viewpixx = 1;           % if this is a viewpixx screen (1) or not (0)