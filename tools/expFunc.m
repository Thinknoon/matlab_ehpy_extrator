function [ y_fit ] = expFunc( beta, x )
%EXPFUNC defined an expotential function, used for expotential fitting. 


y_fit = beta(1)*exp(-x/beta(2))+beta(3);

end

