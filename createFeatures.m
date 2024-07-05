function [Attr,m_FP] = createFeatures(matFilePath)

%% ��ȡ����
matContains = load(matFilePath);
[~, fileName, ~] = fileparts(matFilePath);
m_FP = matContains.m_FP;
StiStep = m_FP.StiStep;
%Ĭ��HEKA�̼���ʼʱ��Ϊ0.1s,����ʱ��Ϊ0.7s,����Ƶ��Ϊ25000
stim_Ind = [2500  17500];
epochStimLevel = m_FP.StiStep;
sampleFrequency = m_FP.fsample;
%ÿ���ļ�ֻ����һ��Series
sweepVoltageData = m_FP.alldt{1}; %��ͬ��ͨ����������ѡ�񣬻���ʹ��forѭ��
totalSweeps = size(sweepVoltageData,2);
si = 1e+6/m_FP.fsample;
sweepVoltageData = filter_3000Lowpass(sweepVoltageData,m_FP.fsample); %�˲����Ը������ݵ�ʵ�����ѡ����
curr_index_0 = m_FP.curr_index_0;
Attr = struct();
%���������
[Attr.tau,Attr.tauStimulation,Attr.fit1] = calculateTau(sweepVoltageData,StiStep,totalSweeps,si,curr_index_0,stim_Ind);
[Attr.Sag_time,Attr.Sag_area,Attr.Sag_value] = calculateSag(sweepVoltageData,sampleFrequency,totalSweeps,stim_Ind);
[Attr.reboundAllSweep,Attr.reboundStimulation,Attr.fit2,Attr.rebound_mV,Attr.reboundSpikeCount] = calculateRebound(sweepVoltageData,StiStep,sampleFrequency,curr_index_0,totalSweeps,stim_Ind);
[Attr.Rm,Attr.restMembPotential] = calculateRm(sweepVoltageData,sampleFrequency,curr_index_0,epochStimLevel,stim_Ind);
[Attr,m_FP.filterline] = calculateSpikeFeatures(sweepVoltageData,epochStimLevel,sampleFrequency,totalSweeps,stim_Ind,Attr);
% plot features:
traceInfoPlot = plotAnalysiedTrace(Attr,sweepVoltageData,totalSweeps,stim_Ind);
saveas(traceInfoPlot,strcat('CheckFigure\',fileName, '-traces-', '.png'));
featurePlot = plotFeatures(Attr,sweepVoltageData,si,totalSweeps,stim_Ind,fileName);
saveas(featurePlot,strcat('CheckFigure\',fileName, '-features-', '.png'));

