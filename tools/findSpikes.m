function [N ,out1] = findSpikes(trace,threshold,stim_Ind)
% THE FUNCTION DETECTS TIME STAMPS OF ACTION POTENTIALS OF NEURONAL DATA.
%
%   Input: 
%       'trace': data, the membrane voltage array of a neuron.
%       'Theshold1': the value set for spike detection.
%   Output:
%       N - the number of spikes detected
%       out1 - time stamps of spike PEAKS.
%
%   Example:
%       [numberOfSpikes, spikePeakT] = findSpikes(data,-10)
%
%   Coded by:  Dr. Ruifeng Liu (Sun-Yatsen University) 


if nargin < 2
    threshold =0;
    stim_Ind = nan;
elseif nargin == 2
    stim_Ind = nan;
end

if (length(stim_Ind) ~= 2) 
    if ~isnan(stim_Ind)
        error('the input argument is incorrect: stim_Ind');
    end
end

% find indices of samples above the threshold.Here, we calculated the
% indices with filtered data so that we can elminated the signal noise
% influence.
% trace_filtered = filter_1000Lowpass( trace, sampleFrequency );
% [crosee_idx,~] = find(trace_filtered > threshold);
% clear('trace_filtered');
    
[crosee_idx,~] = find(trace > threshold);
% if there is at least one sample above the threshold:
if ~isempty(crosee_idx)
    % find the spikes and create the spike edge matrix.
    trace_0 = zeros(length(trace),1);
    trace_0(crosee_idx) = 1;
    tem_d = diff(trace_0);
    spikeEdge_l = find(tem_d == 1);
    spikeEdge_r = find(tem_d == -1);
    if ( length(spikeEdge_l) == length(spikeEdge_r) ) && ( spikeEdge_l(1) > spikeEdge_r(1 ))   % normal condition.
        spike_period = [spikeEdge_l,spikeEdge_r];
    else
        if ( length(spikeEdge_l) == length(spikeEdge_r) ) && ( spikeEdge_l(1) > spikeEdge_r(1 ))   % right part of the first spike in the duration and left part of last spike in the duration.
            spikeEdge_l(1) = [];spikeEdge_r(end) = [];
        elseif ( length(spikeEdge_l) < length(spikeEdge_r) )    % right part of the first spike in the duration 
            spikeEdge_r(1) = [];
        elseif ( length(spikeEdge_l) > length(spikeEdge_r) )  % left part of the last spike in the duration 
            spikeEdge_l(end) = [];
        end
        spike_period = [spikeEdge_l,spikeEdge_r];
    end
    % find the indices of spike peaks.
    nSpike = size(spike_period,1);
    spikePeak = nan(nSpike,1);
    peakValues = nan(nSpike,1);
    for i = 1:nSpike
        data_spike = trace(spike_period(i,1):spike_period(i,2));
        [peakValue,ind_tem] = max(data_spike);
        spikePeak(i) = spike_period(i,1)+ind_tem(1)-1;
        peakValues(i) = peakValue;
    end
%     % ----remove the erroneous spike indices-------
%     % according to spike height.
%     idx_del_1 =  peakValues < mean(peakValues)-5*std(peakValues);
%     spikePeak(idx_del_1)=[];
%     % according to spike intervals.
%     idx_del_2 = [];
%     avgSpikeInterval = mean(diff(spikePeak));
%     interval_del = find(diff(spikePeak)<0.2*avgSpikeInterval);
%     for i = 1:length(interval_del)
%         if trace(spikePeak(i)) < trace(spikePeak(i+1))
%             idx_del_2 = [idx_del_2, interval_del];
%         else
%             idx_del_2 = [idx_del_2, interval_del+1];
%         end
%     end
%      spikePeak(idx_del_2)=[];
else
    spikePeak=[];
end

% ------only includes the spikes during stimulation period---
if ~isnan(stim_Ind)
    spikePeak = spikePeak(spikePeak>stim_Ind(1) );
    spikePeak = spikePeak(spikePeak<stim_Ind(2));
end
% -----------------------------------------------------------

% % plotting...
% figure; plot(trace); hold on; plot(spikePeak, trace(spikePeak),'or');
% hold on; plot([1,length(trace)],[threshold1, threshold1],'r');
% hold off

N=length(spikePeak) ;
out1=spikePeak;
end


