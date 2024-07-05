function [tau,tauStimulation,fit1] = calculateTau(sweepVoltageData,StiStep,totalSweeps,si,curr_index_0,stim_Ind)
%计算所有sweep的Tau
tau = zeros(1,curr_index_0);
tauStimulation=zeros(1,curr_index_0);
fit1 = struct();
for sweep=1:totalSweeps
    if sweep <= curr_index_0
        Voltage_tem = sweepVoltageData(:,sweep);
        Voltage_tem = Voltage_tem(stim_Ind(1):stim_Ind(2)); 
        Voltage_tem = Voltage_tem(1:round(length(Voltage_tem)/3)); 
        Voltage_tem = smooth(Voltage_tem,5);
        Voltage_tem = Voltage_tem(1:find(Voltage_tem==min(Voltage_tem)));
        t = (1:length(Voltage_tem))*si*1e-3;
        beta = tauFit(t',Voltage_tem);
        tau(sweep) = beta(2);
        tauStimulation(sweep) = StiStep(sweep); 
        idx_fitData = [ stim_Ind(1),stim_Ind(1)+length(Voltage_tem) ];
        fit1(sweep).beta1 = beta;
        fit1(sweep).idx_data = idx_fitData;
        [d_fit1] = expFunc( beta, t);
        fit1(sweep).d_fit = d_fit1;
    end
end
end

