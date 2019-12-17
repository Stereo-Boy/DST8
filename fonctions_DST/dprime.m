function dpr=dprime(nbHit,nbFA,nbMiss,nbCR)

%Compute the d' according to the signal detection theory.

%___________________________________
%|              response           |
%|signal  |   yes    |    no       |
%|________|__________|_____________|
%|yes     |  hit     |    Miss     |
%|no      |  FA      |    CR       |
%|________|__________|_____________|
%
%
% See http://brain.mcmaster.ca/SDT/dprime.html

pHit=nbHit./(nbHit+nbMiss);
pFA=nbFA./(nbFA+nbCR);

if pHit==1;     pHit=0.99999999; end
if pHit==0;     pHit=0.000000001; end
if pFA == 1;     pFA=0.99999999; end
if pFA == 0;     pFA = 0.000000001; end

dpr=(norminv(1-pFA,0,1)-norminv(1-pHit,0,1)); 
%It could be abs of that (depending on the proba of inverting the task or the keys) if we consider that if the FA is 2 times greater than the Hit, it means the observer
%is able to discrimate as well as if it is the opposite.



