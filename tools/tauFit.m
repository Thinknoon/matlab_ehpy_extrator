function  [ beta ] = tauFit(t,d)
%SIGMOIDFUNC used for tau fitting in patch clamp recording data. 

A=[]; B=[]; Aeq=[]; Beq=[]; NONLCON=[];
OPTIONS = optimset('fmincon');
OPTIONS = optimset('LargeScale', 'off', 'Display', 'off',  'Algorithm',  'active-set');

data = d-min(d);
yy1 = @(x)sum( ( ( x(1)*exp( -t/x(2) )+x(3))- data ).^2 );
LB = [0    10   -100];   % lower bounds
UB = [100  100   10*max(data) ];   % upper bounds
% initial parameter guesses
beta0 = [mean(data)  20   -100];
% least square fitting
[beta,  ~] = fmincon(yy1,beta0,A,B,Aeq,Beq,LB,UB, NONLCON, OPTIONS); % fminsearch
beta(3) = beta(3)+min(d);

% % plot a figure to validate fiting result.
% figure();
% plot(t,d,'b');
% hold on, plot(t, beta(1)*exp(-t/beta(2))+beta(3),'r');

end



