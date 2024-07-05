function  [ beta ] = reboundFit(t,d)

A=[]; B=[]; Aeq=[]; Beq=[]; NONLCON=[];
OPTIONS = optimset('fmincon');
OPTIONS = optimset('LargeScale', 'off', 'Display', 'off',  'Algorithm',  'active-set');

data = d-min(d);
yy1 = @(x)sum( ( ( x(1)*exp( -t/x(2) )+x(3))- data ).^2 );
LB = [-100    0.001   -100];   % lower bounds
UB = [100  100   10*max(data) ];   % upper bounds
% initial parameter guesses
est = [mean(data)  1   -50];
% least square fitting
[beta,  minfun] = fmincon(yy1,est,A,B,Aeq,Beq,LB,UB, NONLCON, OPTIONS); % fminsearch
beta(3) = beta(3)+min(d);

index = 1
for ii = 1 : 10
    for jj = 1 : 10
        for kk = 1 : 10
            aa = LB(1)+10 + (ii-1)*(UB(1)-LB(1))/10;
            bb = power(10, log10(LB(2))+0.001 + (jj-1)*(log10(UB(2))-log10(LB(2)))/10);
            cc = LB(3)+10 + (kk-1)*(UB(3)-LB(3))/10;
            est = [aa bb cc];
            [tmpbeta(index, :),  tmpminfun(index)] = fmincon(yy1,est,A,B,Aeq,Beq,LB,UB, NONLCON, OPTIONS);
            index = index + 1;
        end
    end
end
[minval,  selindex]  = min(tmpminfun);
beta = tmpbeta(selindex, :);
beta(3) = beta(3)+min(d);
%
% figure();
% plot(t,d,'b');
% hold on, plot(t, beta(1)*exp(-t/beta(2))+beta(3),'r');


