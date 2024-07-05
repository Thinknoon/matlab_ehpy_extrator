function [Sag_time,Sag_area,Sag_value] = calculateSag(sweepVoltageData,sampleFrequency,totalSweeps,stim_Ind)
%计算Sag
si = 1e+6/sampleFrequency;
d1 = filter_1000Lowpass(sweepVoltageData(:,1),25000);
stim_period = d1(stim_Ind(1):round(stim_Ind(2)/3));
[minValue, minIdx]=min(stim_period);
m_height=zeros(1,totalSweeps);
for sweep = 1:totalSweeps % Occassionally, there is spontaneuous spike before the stimulation onset, if there is, select the second sweep to calculate the base value.
    fd = filter_butter(sweepVoltageData(:,sweep),sampleFrequency);
    fd = smooth(fd(round(length(fd)*0.1):end),1001);
%   height =  max(fd) + 20;
    height =  max(fd) + 15;
    if height < -10
        height = -10;
    else 
        height = max(fd) + 15;
         %这里会在命令行打印count1,但是又没有实际使用，因此我们忽略它
        %[count1 ,peak_idx1] = findSpikes(sweepVoltageData(:,sweep),height,stim_Ind);
        [~ ,peak_idx1] = findSpikes(sweepVoltageData(:,sweep),height,stim_Ind);
        height  = (mean(d(peak_idx1, sweep)) +  max(fd))/2;
    end
        m_height(sweep) = height;
    try
        [~,peak_idx] = findSpikes(sweepVoltageData(:,sweep),m_height(sweep));
    catch
        fprintf('current sweep contains spontaneuous spike, goto next sweep to caulculate baseVoltage...\n ')
    end
    if isempty( peak_idx( peak_idx < stim_Ind(1) ) )
        baseValue =mean( sweepVoltageData(100:stim_Ind(1),sweep) ); % actually the rest membrane potential.
        break;
    end
end
steadyValue = mean( d1(stim_Ind(2)-sampleFrequency*0.1:stim_Ind(2)));
Sag_index = abs( (minValue-baseValue)./(steadyValue-baseValue) );
Sag_value = abs( steadyValue-minValue );
d1 = d1(stim_Ind(1) : stim_Ind(2));
% calculate the Sag_time.
if Sag_index>1
    ind_left = find(d1<steadyValue,1,'first');
    ind_right = find(d1(minIdx:end)>steadyValue,1,'first');
    ind_right = ind_right+minIdx-1;
    if isempty(ind_right)
        ind_right=length(d1);
    end
    Sag_time = (ind_right-ind_left)*si*0.001;
    if steadyValue - minValue < 4
        Sag_time = 0;
    end
    yy = d1(ind_left:ind_right);
    xx = (ind_left:ind_right).*si*0.001;
    Sag_area = polyarea(xx',yy);
else
    Sag_time = 0;
    Sag_area = 0;
end  
    
end

