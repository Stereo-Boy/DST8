
Before starting, please replace the values in screen/screen_parameters.m with your actual screen values.
Once done, please do a copy of that file to keep, so that after each github pull, you can retrieve your parameter values.

The function needs the Psychtoolbox and the programs required to run that toolbox (e.g. gstreamer), see on
 http://psychtoolbox.org/download.html

If any error, open the appropriately dated log file in the log folder to see the error and comments.

Troubleshooting:
"PTB-ERROR: You requested a point size of 26.000000 units, which is not in the range (1.000000 to 20.000000) supported by your graphics hardware.
Error in function DrawDots: 	Usage error
Unsupported point size requested in Screen('DrawDots')."

This means that your graphic card can only support dots of a smaller size (in pixels) using the DrawDots function.
The appropriate solution is to decrease the screen resolution so that the point size is smaller.

