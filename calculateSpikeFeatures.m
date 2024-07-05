function [Attr,filterline] = calculateSpikeFeatures(sweepVoltageData,epochStimLevel,sampleFrequency,totalSweeps,stim_Ind,Attr)
%计算Spike相关参数
si = 1e+6/sampleFrequency;
%初始化各电生理参数后计算
numSpikes = zeros(1,totalSweeps);      % restore number of spikes of each sweep.
ISI_adpIdx_slope_last = nan;
ISI_adpIdx_slope_initial = nan;
m_ampAdpIdx_slope = nan;
ISI_adpIdx_initial = nan(1,totalSweeps); % used to record the adaption indices of all sweep traces.
ISI_adpIdx_last= nan(1,totalSweeps);
ISI_adpIdx = nan(1,totalSweeps);
ampAdaptIdx = nan(1,totalSweeps);
late_spikingT = nan(1,totalSweeps);    % restore the latency of first spike relatibe to stimulation onset in each sweep.                      
AHP_value = 1000;                        % used to restore the AHP value.
ADP_value = 1000;
AHP_value3 = nan;
AHP_latency3 = nan;
m_FR = nan;
m_FR_slope = nan;
m_firstISI_slope = nan;
m_firstISI=nan;
m_P_1stISI=nan;
ADP_sweep = [];
AHP_sweep = [];
AHP_idx = [];
AHP_latency=nan;
ADP_latency= nan;
firstISI = nan(1,totalSweeps);
CV = zeros(1,totalSweeps);
AHP_idx3=[];
APproperties = struct();
%plot data初始化
ADP_idx=[];
plotData = struct();
for sweep=1:totalSweeps
    % find spikes. 
    d_sweep = sweepVoltageData(:,sweep);
    try
    [ peak_idx, AP_thresh,ind_thresh,AP_amp, halfAPwidth, AP_rise_t,AP_decay_t, stroke, APHeight ] = anaAP_718( d_sweep, stim_Ind,si );        
    catch
    peak_idx = []; AP_thresh = []; ind_thresh = []; AP_amp = [];  halfAPwidth = [];  AP_rise_t = []; AP_decay_t = [];  stroke = [];  APHeight = []; 
    end
    count = length(peak_idx);
    numSpikes(sweep)  = count;   
    APproperties(sweep).numSpikes = count;
    if ~isempty(peak_idx)
        fprintf('The number of spikes in sweep %d is %d.\n',sweep,count);
        APproperties(sweep).AP_threshold = AP_thresh;
        APproperties(sweep).ind_threshold = ind_thresh;
        APproperties(sweep).AP_amp = AP_amp;
        APproperties(sweep).halfHeightWidth = halfAPwidth;
        APproperties(sweep).AP_rise_t = AP_rise_t;
        APproperties(sweep).AP_decay_t = AP_decay_t;
        APproperties(sweep).idices = peak_idx;
        APproperties(sweep).peaks = d_sweep(peak_idx);
        
        [ phaseTrace, phaseArea, phasePerimeter ] = calSpikePhaseProperties( d_sweep, peak_idx, sampleFrequency, 0);
        APproperties(sweep).phaseTrace = phaseTrace;
        APproperties(sweep).phaseArea = phaseArea;
        APproperties(sweep).phasePerimeter = phasePerimeter;
        APproperties(sweep).stroke = stroke;
        APproperties(sweep).APHeight = APHeight;
        
        % get the late spiking time for each sweep.
        late_spikingT(sweep) = abs( APproperties(sweep).ind_threshold(1)-stim_Ind(1) )*(1/sampleFrequency)*1000;   % unit: ms;
        % calculate the adaptation index for each sweep.
        if ~isempty(peak_idx) && length(peak_idx) > 2
            spike_intervals = diff(peak_idx)*si*0.001;
            ISI_adpIdx(sweep) = spike_intervals(end)/spike_intervals(1);
            ISI_adpIdx_initial(sweep) = spike_intervals(2)/spike_intervals(1);
            ISI_adpIdx_last(sweep) = spike_intervals(end)/spike_intervals(1);
            firstISI(sweep) = spike_intervals(1);
            CV(sweep) = std(spike_intervals)/mean(spike_intervals);    % coefficient of varience.
        end
        
        if ~isempty(peak_idx) && length(peak_idx) >= 2
            ampAdaptIdx(sweep) = AP_amp(2)/AP_amp(1);
        end
    else
        fprintf('no spike in the trace %d.\n',sweep);
    end
    %计算AHP和ADP,这两个需要用到Spike相关参数
    if AHP_value  == 1000 
       if count == 1
            filterline = filter_1000Lowpass( sweepVoltageData(:,sweep),sampleFrequency);
            if peak_idx(1)+int16(5*1000/si)>stim_Ind(2)
                segment_afterSpike = filterline(peak_idx(1):stim_Ind(2));
            else
                segment_afterSpike = filterline(peak_idx(1):peak_idx(1)+int32(5*1000/si) );
                segment_afterSpike3 = filterline(peak_idx(1)+int32(5*1000/si)+1 : stim_Ind(2) );
            end
            [min_tem, idx_tem] = min(segment_afterSpike);
            if ~isempty(segment_afterSpike3)
                [min_tem3, idx_tem3] = min(segment_afterSpike3);
                if idx_tem3 < length(segment_afterSpike3)- 20
                    AHP_value3 = min_tem3 - APproperties(sweep).AP_threshold(1);
                    AHP_latency3 = 5 + (idx_tem3)*si*0.001;
                    AHP_idx3 = peak_idx(1)+int32(5*1000/si) + idx_tem3(1);
                else
                    AHP_value3 = nan;
                    AHP_latency3 = nan;
                end
            else
                AHP_value3 = nan;
                AHP_latency3 = nan;
            end
            if idx_tem < length(segment_afterSpike)-5 % idx_tem < 50*1000/si % if there is a trough within 50ms following a spike was defined as AHP.
                AHP_value = min_tem - APproperties(sweep).AP_threshold(1);
                AHP_value_abs = min_tem ;
                if AHP_value >= 0
                    AHP_value = nan;
                end 
                AHP_sweep = sweep;
                AHP_idx = peak_idx(1) + idx_tem(1);
                AHP_latency = idx_tem*si*0.001;  % time from AP peak to the trough bottom of AHP, unit: ms.
            else
                AHP_value = nan;
                AHP_value_abs = nan;
            end
        elseif count > 1
                filterline = filter_1000Lowpass( sweepVoltageData(:,sweep),sampleFrequency);
                segment_afterSpike = filterline(peak_idx(1):peak_idx(1)+int32(5*1000/si) );
                [min_tem, idx_tem] = min(segment_afterSpike);
                AHP_value = min_tem - APproperties(sweep).AP_threshold(1);
                AHP_value_abs = min_tem ; 
                if AHP_value >= 0
                        AHP_value = nan;
                end
                AHP_sweep = sweep;
                AHP_idx = peak_idx(1) + idx_tem(1);
                AHP_latency = idx_tem*si*0.001;  % time from AP peak to the trough bottom of AHP, unit: ms.
                
                segment_afterSpike3 = filterline(peak_idx(1)+int32(5*1000/si)+1 : peak_idx(2));
                if ~isempty(segment_afterSpike3)
                    [min_tem3, idx_tem3] = min(segment_afterSpike3);
                    if  idx_tem3 < length(segment_afterSpike3)- 20
                        AHP_value3 = min_tem3 - APproperties(sweep).AP_threshold(1);
                        AHP_latency3 =5+ idx_tem3*si*0.001;
                        AHP_idx3 = peak_idx(1)+int32(5*1000/si) + idx_tem3(1);
                    else
                        AHP_value3 = nan;
                        AHP_latency3 = nan;
                    end
                else
                    AHP_value3 = nan;
                    AHP_latency3 = nan;
                end        
       end
    end
    %ADP的计算是依赖AHP的，接着进行ADP的计算            
    if ADP_value == 1000&&AHP_value < 0
        if count >= 1
            adplen_index = AHP_idx(1)+int32(25*1000/si);
            if count >= 2 &&  adplen_index >  APproperties(sweep).ind_threshold(2)
                adplen_index = APproperties(sweep).ind_threshold(2) ;
            end
            filterline = filter_1000Lowpass( sweepVoltageData(:,sweep),sampleFrequency);
            segment_afterSpike2 = filterline(AHP_idx(1): adplen_index);
            [max_tem, idx_tem2] = max(segment_afterSpike2);
            %%
            ADP_value = max_tem(1) - AHP_value_abs;
            ADP_sweep = sweep; %该值是用于画图
            ADP_idx = AHP_idx(1) + idx_tem2(1);
            ADP_latency = AHP_latency + idx_tem2(1)*si*0.001;  % time from AHP trough to top before next AP, unit: ms.
            
            if ADP_value < 0  ||  idx_tem2 > length(segment_afterSpike2) -10
                ADP_value = nan;
                ADP_idx = nan;
                ADP_latency = nan;
            end
        end
     end
end      
%

plotData.AHP_sweep = AHP_sweep;
plotData.AHP_idx = AHP_idx;
%继续计算Spike相关参数
nSpike = nonzeros(numSpikes);    % find the all non-nan threshold (the stimulation evoked action potentials. idx(1) is the index of the nearest threshold stimulation trace.
if ~isempty(nSpike)
    [~, idx_sweep1]  = find(numSpikes == nSpike(1),1);  % find the nearest threshold stimulation sweep.
    [~, idx_sweep2]  = find(numSpikes == max(nSpike),1);
else
    idx_sweep1 = [];
    idx_sweep2 = [];
end
%storage for plotting...
plotData.idx_sweep1=idx_sweep1;
plotData.idx_sweep2=idx_sweep2;
if numSpikes(idx_sweep2) >=3
    [ISI_phaseT_ratio,ISI_phaseT_ratio_CV] = ISItrough_Phases(sweepVoltageData(:,idx_sweep2), APproperties(idx_sweep2).idices);
else
    ISI_phaseT_ratio = nan;
    ISI_phaseT_ratio_CV = nan;
end
%计算Spike
if ~isempty(numSpikes(idx_sweep2)) && numSpikes(idx_sweep2) > 2
    aveAPwidth_maxSweep = mean(APproperties(idx_sweep2).halfHeightWidth(2:end));
    APwidth_ratio = APproperties(idx_sweep2).halfHeightWidth(1)/aveAPwidth_maxSweep;
    Amps = APproperties(idx_sweep2).AP_amp;
    %ampAdaptIdx = Amps(1)/Amps(2);     % old : ampRatio = Amps(1)/mean(Amps(2:end));
    amp_ratio = Amps(1)/Amps(end);
    amp_FanoFactor = std(Amps)^2/mean(Amps);
    amp_CV =  std(Amps)/mean(Amps);
    % calculate the ISI related values.
    peakIndices = APproperties(idx_sweep2).idices;
    ISIs = diff(peakIndices)*si*0.001;    % unit: ms.
    ISI_adpIdx_max = ISIs(2)/ISIs(1);
    ISI_ratio = ISIs(end)/ISIs(1);
    ISI_CV = std(ISIs)/mean(ISIs);
    ISI_FanoFactor = std(ISIs)^2/mean(ISIs);
else
    APwidth_ratio = nan;
    %ampAdaptIdx = nan;
    aveAPwidth_maxSweep = nan;
    amp_ratio = nan;
    amp_FanoFactor=nan;
    amp_CV=nan;
    ISI_adpIdx_max = nan;
    ISI_ratio = nan;
    ISI_CV = nan;
    ISI_FanoFactor = nan;
end

% calculate the sweep slopes...
FR_slope = nan;
firstISI_slope = nan;
latency_slope = nan;
ISI_adpIdx_slope = nan;
ampAdpIdx_slope = nan;
stimLevels_latency=[];
latencies = [];
stimLevels_FR = [];
FR=[];
m_FRP=[];
P_ISIadpIdx_slope_inital=[];
stimLevels_1stISI = [];
stimLevels_adpIdx = [];
m_stimLevels_1stISI=[];
stimLevels_adpIdx_initial=[];
firstAmpAdpIdx_select = [];
ind_adpIdx = [];
m_stilevel=[];
m_P_ampAdaptIdx=[];
stimLevels_ampAdpIdx=[];
P_latency = nan(2,1);
P_FR = nan(2,1);
P_1stISI=nan(2,1);
P_ISIadpIdx=nan(2,1);
P_ampAdaptIdx=nan(2,1);
if sum(~isnan(late_spikingT) ) >= 5 && idx_sweep2-idx_sweep1>=4
    late_spikingT(idx_sweep2+1:end)=nan;     % exclude the sweeps with too high current input (firing rate less than the maximal sweeps)
    latencies = late_spikingT(~isnan((late_spikingT))).*0.001;   % change the unit to 'second', other wise the slope is too small.
    stimLevels_latency = epochStimLevel(~isnan(late_spikingT));
    P_latency = polyfit(stimLevels_latency,1./latencies,1);   % linear fit.
    latency_slope = P_latency(1);
    
    FR = numSpikes/(diff(stim_Ind)*si*1e-6);
    [~,ind_t]=find(diff(FR)>0);
    ind_t0=ind_t+1;
    stimLevels_FR = epochStimLevel(ind_t0);
    FR = FR(ind_t0);
    if length(stimLevels_FR)>=5
        stimLevels_FR(6:end) = [];
        P_FR = polyfit(stimLevels_FR,FR(1:5),1);   % linear fit.
    else
        stimLevels_FR= [];
        P_FR = [nan,nan];
    end
    FR_slope = P_FR(1);
    %% get FI-slope
    m_FR = numSpikes(idx_sweep1 :  idx_sweep2)/(diff(stim_Ind)*si*1e-6);
    m_stilevel =  epochStimLevel(idx_sweep1 :  idx_sweep2);
    if length(m_stilevel)>=5
        m_FRP = polyfit(m_stilevel,m_FR,1);   % linear fit.
    else
        m_stilevel= [];
        m_FRP = [nan,nan];
    end
    m_FR_slope = m_FRP(1);
    %%下面注释的3句话原本就有，但是在后面又赋值了一次
    %ind_t=~isnan(firstISI);
    %ind_t(ind_t >  idx_sweep2) = [];
    %m_stimLevels_1stISI = firstISI(ind_t);
    m_firstISI   =   firstISI;
    ind_t=~isnan(firstISI);
    stimLevels_1stISI = epochStimLevel(ind_t);
    firstISI = firstISI(ind_t);
    if length(stimLevels_1stISI)>=5
        stimLevels_1stISI(6:end) = [];
        P_1stISI = polyfit(stimLevels_1stISI,firstISI(1:5),1);
    else
        stimLevels_1stISI= [];
        P_1stISI = [nan,nan];
    end
    firstISI_slope = P_1stISI(1);
    
    m_firstISI(idx_sweep2+1:end)=nan;
    ind_t=~isnan(m_firstISI);
    m_stimLevels_1stISI = epochStimLevel(ind_t);
    m_firstISI = m_firstISI(ind_t);
    if length(m_stimLevels_1stISI)>=5
        m_P_1stISI = polyfit(m_stimLevels_1stISI, m_firstISI,1);
    else
        m_stimLevels_1stISI= [];
        m_P_1stISI = [nan,nan];
    end
    m_firstISI_slope = m_P_1stISI(1);
    
    ISI_adpIdx(idx_sweep2+1:end) = nan; % exclude the sweeps with too high current input (firing rate less than the maximal sweeps)
    [ind_adpIdx]=~isnan(ISI_adpIdx);
    stimLevels_adpIdx = epochStimLevel(ind_adpIdx).*1e-3;  % change the input current unit from pA to nA, so that the slope value is moderate ( avoid too small.)
    if length(stimLevels_1stISI)>=3
        P_ISIadpIdx = polyfit(stimLevels_adpIdx,ISI_adpIdx(ind_adpIdx),1);
    else
        P_ISIadpIdx = [nan,nan];
    end
    ISI_adpIdx_slope = P_ISIadpIdx(1);
    ISI_adpIdx_slope_last = ISI_adpIdx_slope;
    
    ISI_adpIdx_initial(idx_sweep2+1:end) = nan; % exclude the sweeps with too high current input (firing rate less than the maximal sweeps)
    [ind_adpIdx2]=~isnan(ISI_adpIdx_initial);
    stimLevels_adpIdx_initial = epochStimLevel(ind_adpIdx2).*1e-3;  % change the input current unit from pA to nA, so that the slope value is moderate ( avoid too small.)
    ISI_adpIdx_initial = ISI_adpIdx_initial(ind_adpIdx2);
    if length(stimLevels_1stISI)>=3
        P_ISIadpIdx_slope_inital = polyfit(stimLevels_adpIdx_initial, ISI_adpIdx_initial, 1);
    else
        P_ISIadpIdx_slope_inital = [nan,nan];
    end
    ISI_adpIdx_slope_initial =  P_ISIadpIdx_slope_inital(1);   
    ampAdaptIdx(idx_sweep2+1:end)=nan;
    [ind_t]=~isnan(ampAdaptIdx);
    stimLevels_ampAdpIdx = epochStimLevel(ind_t).*1e-3;
    firstAmpAdpIdx_select = ampAdaptIdx(ind_t);
    if length(firstAmpAdpIdx_select)>4
        P_ampAdaptIdx = polyfit(stimLevels_ampAdpIdx(1:5),firstAmpAdpIdx_select(1:5),1);
        m_P_ampAdaptIdx = polyfit(stimLevels_ampAdpIdx,firstAmpAdpIdx_select,1);
    else
        P_ampAdaptIdx = [nan,nan];
        m_P_ampAdaptIdx = [nan,nan];
    end
    ampAdpIdx_slope = P_ampAdaptIdx(1);
    m_ampAdpIdx_slope = m_P_ampAdaptIdx(1);
end
Rheobase = epochStimLevel(idx_sweep1);
threshold = APproperties(idx_sweep1).AP_threshold(1);            % get the first non-nan threshold (the nearest threshold stimulation trace)
halfAPwidth = APproperties(idx_sweep1).halfHeightWidth(1);
AP_Amp = APproperties(idx_sweep1).AP_amp(1);
AP_rise_t = APproperties(idx_sweep1).AP_rise_t(1);
AP_decay_t = APproperties(idx_sweep1).AP_decay_t(1);
if  ~isempty(AP_rise_t) && ~isempty(AP_decay_t)
    risDecayRatio = AP_rise_t/AP_decay_t;
else
    risDecayRatio = nan;
end
latSpikeT = late_spikingT(idx_sweep1);
maxSpikeNum = numSpikes(idx_sweep2);
maxFiringRate = maxSpikeNum/(diff(stim_Ind)*si*1e-6);
if isnan(AHP_value)
    ADP_value = nan;
end

%%
%将画图的数据打包到plotData
plotData.stimLevels_latency=stimLevels_latency;
plotData.P_latency=P_latency;
plotData.late_spikingT=late_spikingT;
plotData.m_stilevel=m_stilevel;
plotData.stimLevels_FR=stimLevels_FR;
plotData.P_FR=P_FR;
plotData.FR=FR;
plotData.m_FRP=m_FRP;
plotData.m_stimLevels_1stISI=m_stimLevels_1stISI;
plotData.stimLevels_1stISI=stimLevels_1stISI;
plotData.P_1stISI=P_1stISI;
plotData.m_firstISI=m_firstISI;
plotData.m_P_1stISI=m_P_1stISI;
plotData.stimLevels_adpIdx_initial=stimLevels_adpIdx_initial;
plotData.ind_adpIdx = ind_adpIdx;
plotData.stimLevels_adpIdx=stimLevels_adpIdx;
plotData.P_ISIadpIdx = P_ISIadpIdx;
plotData.ISI_adpIdx_initial=ISI_adpIdx_initial;
plotData.P_ISIadpIdx_slope_inital=P_ISIadpIdx_slope_inital;
plotData.firstAmpAdpIdx_select=firstAmpAdpIdx_select;
plotData.P_ampAdaptIdx=P_ampAdaptIdx;
plotData.m_P_ampAdaptIdx=m_P_ampAdaptIdx;
plotData.ADP_sweep=ADP_sweep;
plotData.ADP_idx = ADP_idx;
plotData.latencies=latencies;
plotData.m_FR = m_FR;
plotData.firstISI = firstISI; 
plotData.ISI_adpIdx = ISI_adpIdx;
plotData.stimLevels_ampAdpIdx=stimLevels_ampAdpIdx;
plotData.CV=CV; % CV似乎是没有参与什么计算，但是原来的代码就是这样的，也作为一个值存储
plotData.AHP_idx3 = AHP_idx3; % AHP_idx3似乎是没有参与什么计算，但是原来的代码就是这样的，也作为一个值存储
%%
Attr.stim_Ind = stim_Ind;
Attr.threshold = threshold(1);            % get the first non-nan threshold (the nearest threshold stimulation trace)
Attr.halfAPwidth = halfAPwidth(1);
Attr.AP_Amp =AP_Amp(1);
Attr.AP_rise_t = AP_rise_t(1);
Attr.AP_decay_t = AP_decay_t(1);
Attr.risDecayRatio = risDecayRatio;
Attr.latSpikeT = latSpikeT;
Attr.maxSpikeNum = maxSpikeNum;
Attr.maxFiringRate = maxFiringRate;
Attr.AHP_value = AHP_value;
Attr.sAHP_value = AHP_value3;
Attr.ADP_value = ADP_value;
Attr.ADP_latency = ADP_latency;
Attr.AHP_sweep=AHP_sweep;
Attr.AHP_latency = AHP_latency;
Attr.sAHP_latency = AHP_latency3;
Attr.APproperties = APproperties;
Attr.Rheobase = Rheobase;
Attr.AP_widthRatio = APwidth_ratio;
Attr.ampAdaptIdx_atmaxFR = ampAdaptIdx(idx_sweep2);
Attr.amp_ratio = amp_ratio;
Attr.amp_FanoFactor = amp_FanoFactor;
Attr.amp_CV = amp_CV;
Attr.ISI_FanoFactor = ISI_FanoFactor;
Attr.ISI_adpIdx_atmaxFR = ISI_adpIdx_max;   % at  max firing rate
Attr.ISI_ratio_atmaxFR = ISI_ratio;
Attr.ISI_CV = ISI_CV;
Attr.ISI_phaseT_ratio = ISI_phaseT_ratio;
Attr.ISI_phaseT_ratio_CV = ISI_phaseT_ratio_CV;
Attr.aveAPwidth_maxSweep = aveAPwidth_maxSweep;
Attr.latency_slope = latency_slope;
Attr.FR_slope = FR_slope;     % the first five
Attr.m_FR_slope = m_FR_slope; % the whold
Attr.firstISI_slope = firstISI_slope;
Attr.m_firstISI_slope = m_firstISI_slope;
Attr.ISI_adpIdx_slope = ISI_adpIdx_slope;
Attr.ISI_adpIdx_slope_last = ISI_adpIdx_slope_last;
Attr.ISI_adpIdx_slope_initial = ISI_adpIdx_slope_initial;
Attr.ampAdpIdx_slope = ampAdpIdx_slope;
Attr.m_ampAdpIdx_slope = m_ampAdpIdx_slope;
Attr.idx_sweep_rhoebase = idx_sweep1;
Attr.idx_sweep_maxFR = idx_sweep2;
Attr.firstSpikePhaseArea = APproperties(idx_sweep1).phaseArea(1);
Attr.firstSpikePhasePerimeter = APproperties(idx_sweep1).phasePerimeter(1);
Attr.spikePhaseAreaRatio = APproperties(idx_sweep2).phaseArea(1)/mean(APproperties(idx_sweep2).phaseArea(2:end));
Attr.spikePhasePerimeterRatio = APproperties(idx_sweep2).phasePerimeter(1)/mean(APproperties(idx_sweep2).phasePerimeter(2:end));
spk=zeros(1,length(Attr.APproperties));
AP_Amps=zeros(length(Attr.APproperties),2);
m_ISIs=zeros(length(Attr.APproperties),3);
for ii = 1 : length(Attr.APproperties)
    spk(ii)= Attr.APproperties(ii).numSpikes;
    if isempty(Attr.APproperties(ii).AP_amp)
        AP_Amps(ii, :)= [0  0];
        m_ISIs(ii, :) = [0 0 0];
    else
        if  length(Attr.APproperties(ii).AP_amp) == 1
            AP_Amps(ii, :)= [0  0];
        else
            AP_Amps(ii, :)= Attr.APproperties(ii).AP_amp(1:2);
        end
        if  length(Attr.APproperties(ii).AP_amp) < 3
            m_ISIs(ii, :) = [0 0 0];
        else
            m_ISIs(ii, :)= [Attr.APproperties(ii).idices(2)-Attr.APproperties(ii).idices(1)   Attr.APproperties(ii).idices(3)-Attr.APproperties(ii).idices(2)  Attr.APproperties(ii).idices(end)-Attr.APproperties(ii).idices(end-1)] ;
        end
        
    end
end
index = find(spk >=  2);
if length(index) > 5
    selindex = index(1) : index(5);
else
    selindex = index;
end
ampAdaptIdx = median(AP_Amps(selindex, 2)./AP_Amps(selindex, 1));
Attr.ampAdaptIdx = ampAdaptIdx;


index = find(spk >= 3);
if length(index) > 5
    selindex1 = index(1) : index(5) ;
else
    selindex1 = index;
end
if max(spk) >=  3
    ISIAdaptIdx = median( m_ISIs(selindex1, 2)./m_ISIs(selindex1, 1));
    Attr.ISIAdaptIdx = ISIAdaptIdx;
    Attr.ISIAdaptIdx_initial = median( m_ISIs(selindex1, 2)./m_ISIs(selindex1, 1));
    Attr.ISIAdaptIdx_last = median( m_ISIs(selindex1, 3)./m_ISIs(selindex1, 1));
    Attr.ISI_ratio = Attr.ISIAdaptIdx_last;
else
    Attr.ISIAdaptIdx = nan;
    Attr.ISIAdaptIdx_initial = nan;
    Attr.ISIAdaptIdx_last = nan;
    Attr.ISI_ratio = nan;
end
Attr.plotData=plotData;
end


