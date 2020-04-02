function [F]=old_fcdf(x,nu1,nu2)
%
% CALL: fcdf(x,nu1,nu2)
%
y=nu2/(nu2+nu1*x);
F=1-old_betainc(y,nu2/2,nu1/2);
%end
