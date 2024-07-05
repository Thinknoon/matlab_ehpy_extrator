function [mean_thresh sd_thresh N thresvalue thres_coords_orginal]=Spike_threshold_PS3(trace,dt,win, win2, Fc,factordvdt, threshold, stim_Ind)

%%  Spike threshold detection alogrithm - Method II
%   This function calculates the spike threshold of a membrane potential
%   recording based on the method by Sekerli et al IEEE Trans Biom Eng
%   51(9): 1665-1672, 2004. In this paper they suggest two methods of
%   estimating threshold. Here we use the second method, which is based on
%   revealing the threshold in a phase plot of V versus the derivative
%   dVdt. The largest increase in slope is an indication of the threshold. 

%%  INPUT:
%   trace: Vm recording containing the spikes for which the threshold to
%   determine
%   dt: sampling interval in seconds
%   Fc: cut-off frequency for low pass filtering, default value is 5000 Hz
%   win: the half-window size in data points around the spike to show, default is
%   200 points.
%   win2: the window from the peak backwards in time in which the threshold
%   is found. Default value is 100 datapoints
%   factordvdt: is the factor times the max derivative in Vm, as a minimum to
%   include in the analysis. This is to limit the divergent data points.
%   Default is 0.03
%
%%  OUTPUT
%   mean_thresh: mean of threshold values
%   sd_thresh: standard deviation of threshold values
%   N: number of spikes
%   thresvalue: the threshold values
%   thres_coords_orginal: the x-cords of the filtered trace, which is
%   approximately the same as the original.
% 
%   Sample :  [mean_thresh sd_thresh N thresvalue thres_coords_orginal]=Spike_threshold_PS2(trace,5*10^-4,100, 100, 1000,0.03)

%   Rune W. Berg 2015
%   University of Copenhagen
%   rune@berg-lab.net, runeb@sund.ku.dk
%   www.berg-lab.net
thresvalue = [];
thres_coords_orginal = [];
%factordvdt=0.03 ;
%win=100; win2=50; 
win3=3 ; % Number of points to exclude prior to spike peak
%
%clear spiketrace; clear dvdt; clear d2vdt2; clear d3vdt3; clear hh; clear g
% Filtering the trace
%Fc =[1000]; 
% [b1,a1]=butter(2,2*Fc*dt, 'low'); % low pass butterworth filter
% trace2 = filter(b1,a1,trace);  % Filtered trace to minimize noise
trace2 = trace;
% [N ,spikecords]=spike_times(trace2,0);   % N is the number of spikes in the trace. 

[N ,spikecords] = findSpikes(trace2, threshold,stim_Ind);
if N > 2
 if win > min(diff(spikecords))*1/2
     win = round(min(diff(spikecords))*1/2);
     win2 = round(2*win/3);
 end
 
if win > spikecords(1)-stim_Ind(1)
     win = round(spikecords(1)-stim_Ind(1));
     win2 = round(2*win/3);
 end
end

base=1:2*win+1 ; g=zeros(N,2*win+1);  hh=zeros(N,2*win+1);
    
for i=1:N
    spiketrace(i,:)=trace2(spikecords(i)-win:spikecords(i)+win);     % Selecting trace around spike
    dvdt(i,:)=[diff(spiketrace(i,:),1) 0];                          % First derivative
    setNZ=find(dvdt(i,:)>factordvdt*max(dvdt(i,:))) ;               % This value limits the divergent points
    d2vdt2(i,:)=[diff(spiketrace(i,:),2) 0 0];                      % second derivative
    d3vdt3(i,:)=[diff(spiketrace(i,:),3) 0 0 0];                      % third derivative
    g(i,setNZ)=d2vdt2(i,setNZ)./dvdt(i,setNZ);                      % Metric for which the maximum indicate threshold
    hh(i,:)=[diff(g(i,:),1) 0];                      % Metric for which the maximum indicate threshold
    %hh(i,setNZ)=(d3vdt3(i,setNZ).*dvdt(i,setNZ)-d2vdt2(i,setNZ).^2)./(dvdt(i,setNZ).^3);                      % Metric for which the maximum indicate threshold
    
    setNZwin2=find(setNZ<win & (setNZ>win-win2))+win-win2 ;         % points in win2 before peak of spike
    try,
    thres_coord(i)=min(find(hh(i,win-win2:win-win3) == max(hh(i,win-win2:win-win3))))+win-win2-1 ;
    
        
    thresvalue(i)=spiketrace(i,thres_coord(i));
    thres_coords_orginal(i)=spikecords(i)-win+thres_coord(i) ;
    
    catch,
        xx = 0;
    end
    
    if  i == 1 
       if  spikecords(i)-win < stim_Ind(1)
           step =  stim_Ind(1) - (spikecords(i)-win) ; 
           hh1  =[diff(g(i,  step : end),1) 0]
           thres_coord(i)=min(find(hh1(1:win-win3) == max(hh1(1:win-win3))))-1 +step;
           thresvalue(i)=spiketrace(i,thres_coord(i));
           thres_coords_orginal(i)=step-1+spikecords(i)-win+thres_coord(i);
       end
    end


    clear setNZ; clear setNZwin2
end

mean_thresh=mean(thresvalue) ;   sd_thresh=std(thresvalue) ;

end