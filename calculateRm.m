function [Rm,restMembPotential] = calculateRm(sweepVoltageData,sampleFrequency,curr_index_0,epochStimLevel,stim_Ind)
%计算Rm和restMembPotential
%选用特定的sweeps计算Rm
sweeps = curr_index_0-4 :curr_index_0;
stimLevels = epochStimLevel(sweeps);
stim_period_seg = sweepVoltageData(round(stim_Ind(2)-0.1*sampleFrequency):stim_Ind(2),sweeps);
aveVoltages = mean(stim_period_seg,  1);
P = polyfit(stimLevels,aveVoltages,1);  
Rm = P(1)*1000;
d_tem = sweepVoltageData( 100:stim_Ind(1),1:curr_index_0-1);
restMembPotential = mean(d_tem,'all');
end

