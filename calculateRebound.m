function [reboundAllSweep,reboundStimulation,fit2,rebound_mV,reboundSpikeCount] = calculateRebound(sweepVoltageData,StiStep,sampleFrequency,curr_index_0,totalSweeps,stim_Ind)
%计算rebound
si = 1e+6/sampleFrequency;
sweepVoltageData = filter_3000Lowpass(sweepVoltageData,sampleFrequency);
reboundAllSweep = zeros(1,curr_index_0);
reboundStimulation = zeros(1,curr_index_0);
m_height=zeros(1,totalSweeps);
reboundSpikeCount=zeros(1,totalSweeps);
for sweep=1:totalSweeps
    if sweep <= curr_index_0
        fd = filter_butter(sweepVoltageData(:,sweep),sampleFrequency);
        fd = smooth(fd(round(length(fd)*0.1):end),1001);
        %height =  max(fd) + 20;
        height =  max(fd) + 15;
        if height < -10
            height = -10;
        else 
            height = max(fd) + 15;
            %这里会在命令行打印count1,但是又没有实际使用，因此我们忽略它
            %[count1 ,peak_idx1] = findSpikes(sweepVoltageData(:,sweep),height,stim_Ind);
            [~ ,peak_idx1] = findSpikes(sweepVoltageData(:,sweep),height,stim_Ind);
            height  = (mean(sweepVoltageData(peak_idx1, sweep)) +  max(fd))/2;
        end
            m_height(sweep) = height;
        %找Spike, 如果有Spike,计算rebound需要过滤掉。
        d_afterStim = sweepVoltageData(stim_Ind(2):end,sweep);
        %这里会在命令行打印out1,但是又没有实际使用，因此我们忽略它
        %[N ,out1] = findSpikes(d_afterStim,m_height(1),[1,length(d_afterStim)]);
        [N ,~] = findSpikes(d_afterStim,m_height(1),[1,length(d_afterStim)]);
        reboundSpike = N;
        reboundSpikeCount(sweep)=reboundSpike;
        if N > 0
            fprintf('Spike found after stimulating, needing filtering');
        end
       % calculate the rebound value
        dt = sweepVoltageData(:,sweep);
        membPotential_tem = mean( dt(100:stim_Ind(1)));
        if reboundSpike
            dt = dt(stim_Ind(2):end);
            filter_dt = filter_300Lowpass(dt,sampleFrequency);
            ddt = diff(smooth(filter_dt,5));
            dddt = smooth(diff(ddt),5);
            [~,idx] = max(dddt(20:end));
            idx = idx+20-1;
            dt = dt(1:idx);
            t = (1:length(dt))*si*1e-3; % unit is ms.
        else
            dt = filter_300Lowpass(dt,sampleFrequency);
            [~,max_idx] = max(dt(stim_Ind(2):end));
            %%这一段作用是有些数据比较差，没有rebound,在刺激结束时电压最高，直接判为0,并且跳出后面的计算
            if max_idx<15
                reboundAllSweep(sweep)=0;
                continue
            end
             %%
            dt = smooth(dt(stim_Ind(2)+10:stim_Ind(2)-1+max_idx),5);
            t = (1:length(dt))*si*1e-3; % unit is ms.
        end
        [beta2] = reboundFit(t',dt);
        idx_fitData = [stim_Ind(2), stim_Ind(2)+length(dt)];
        [d_fit2] = expFunc(beta2, t);
        fit2.beta2 = beta2;
        fit2.idx_data = idx_fitData;
        fit2.d_fit = d_fit2;
        reboundAllSweep(sweep) = max(d_fit2)-membPotential_tem;
        reboundStimulation(sweep)=StiStep(sweep);
    end
end
rebound_mV = max(reboundAllSweep);
end

