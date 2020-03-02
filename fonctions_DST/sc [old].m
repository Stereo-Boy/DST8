function sortie=sc(lum,box)
%screen luminance linear calibration
%Corrects the screen display
%
%arg:
%lum (candela/m2)=>luminance that must be displayed
%return the 0-255 (bit) value
%
%Function created by Adrien Chopin, 2007
%-----------------------------------------------------------------------

%-----------------------------------------------------------------------
%   Box Value
%-----------------------------------------------------------------------
    %   1   box h429b stereoscope 1 meter distance, behind the mirrors 
    %   2   box H421, left side, mac ZHE781, stereoscope 100cm, sony triniton de Mark
    %   3   box H421, mac ZHE581, sony screen, left on the new setup
    %   4   box 514, Blake Lab, mac G5
    %   5   Blake Lab, Nashville, box 611AAA (right), Mac Pro
    %   16, 18, 19   Standard values for laptop Latitude E3660 Argent
    %   17  Bavelier Lab, Geneve, box 2, PC Windows 7 - 64bit, ViewPixx Screen
    %   19: laptop Latitude E3660 Argent 
    %   20  Levi Lab Screen, Berkeley, SONY screen in Levi Lab (Triniton Multiscan G500 - room 487) - light on
    %   21  Levi Lab Screen, Berkeley, NEC SuperBright Diamondtron MultiSync FP2141SB screen in Levi Lab (room 487 -eye tracker spot)
    %   23  additional screen to laptop Latitude E3660 Argent
    %   24  Screen parameter Box2 ViewPixx1
if ~exist('box','var');box=16; warning('Luminance calibration not defined - using default values');end %default box

%-----------------------------------------------------------------------
%   Newest box Value
%-----------------------------------------------------------------------    
    %  recently, we started to work differently: we are storing the
    %  paramOptim values in the box variable somewhere else
    %  Then, if box is more than one number, there are those values.   
    if numel(box)>1
        paramOptim(1)=box(1);
        paramOptim(2)=box(2);
    else

        switch box
            case {1} %max luminance is 32 cd/m2
                paramOptim(1)=0.0006;
                paramOptim(2)=1.969; 
            case {2} %max is 113 cd/m2
    %             paramOptim(1)=0.0613;
    %             paramOptim(2)=1.3346;

                  %max is 25cdm2
                  paramOptim(1)=0.0127;
                  paramOptim(2)=1.3701;
            case {3} 
    %             paramOptim(1)=0.0028;
    %             paramOptim(2)=1.6468;
                paramOptim(1)=0.0069; %new setup
                paramOptim(2)=1.4998;
            case {4} 
                paramOptim(1)=0.0006;
                paramOptim(2)=1.9435;
            case {5}      
                 paramOptim(1)=0.000021877;
                 paramOptim(2)=2.6837;
           case {16, 18, 19} 
                 paramOptim(1)=0.000021877;
                 paramOptim(2)=2.6837;
           case {17} 
    %              paramOptim(1)=0.0000002253;
    %              paramOptim(2)=3.4075;
    %New viewpixx
                 paramOptim(1)=0.00000033;
                 paramOptim(2)=3.4275;
            case {19,20}
                paramOptim(1)=  0.0062  ; 
                paramOptim(2)= 1.7274;
            case {21, 22, 23}
                paramOptim(1)= 0.0001  ;
                paramOptim(2)= 2.3811 ;
            case {24}
                paramOptim(1)= 0.0010  ; %0.0001
                paramOptim(2)= 2.0879 ; %2.4721
        end
    end
    sortie=(lum./paramOptim(1)).^(1/paramOptim(2));
   % sortie=lum;
    
    %CEILING TO 255 ANYWAY
    sortie=min(255,sortie);
