function [ data_new ] = filter_1000Lowpass( WB_data, adfreq )
%FILTER_WB Summary of this function goes here
%   Detailed explanation goes here



FilterOrder   =  2;                                   % order of filter
FilterCutOff  =  1000;                                 % cutoff freq for filter
FilterType    =  'butter';                            % type of filter

[a,b]= feval(FilterType,FilterOrder,FilterCutOff/(0.5*adfreq),'low');

data_new          = filtfilt(a,b,WB_data);







end

