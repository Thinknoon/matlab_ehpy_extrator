function [ data_new ] = filter_butter( trace, adfreq )
%filter_butter Summary of this function goes here
%   Detailed explanation goes here



FilterOrder   =  1;                                   % order of filter
FilterCutOff  =  5;                                   % cutoff freq for filter
FilterType    =  'butter';                            % type of filter

[a,b]= feval(FilterType,FilterOrder,FilterCutOff/(0.5*adfreq),'low');

data_new = filtfilt(a,b,trace);







end

