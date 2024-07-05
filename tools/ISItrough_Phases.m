function [meanRation,CV] = ISItrough_Phases(d, peakIndices)
%AHPTROUGH_DOWN_UPPHASE 此处显示有关此函数的摘要
%   此处显示详细说明



% % for test, an typical Ext neuron.
% clear all;
% load('E:\workDocs\VEN2\electroData\tem\20220429AS\20220429VENAS01C04.mat')
% d = m_FP.alldt{1}(:,24);
% fsample = m_FP.fsample;
% peakIndices = Attr.APproperties(24).idices;

% load('E:\workDocs\VEN2\electroData\tem\20220429AS\20220429VENAS05C17.mat')
% d = m_FP.alldt{1}(:,20);
% fsample = m_FP.fsample;
% peaks = Attr.APproperties(20).idices;



% find the data traces...
% d = filter_300Lowpass(d,25000);
for i = 1:length(peakIndices)-1
    d_ISI = d(peakIndices(i):peakIndices(i+1));
    [~,minIdx] = min(d_ISI);
    d_down = d_ISI(1:minIdx);
    [~,maxIdx] = max(d_down);
    d_down = d_down(maxIdx:end);
    
%     d_up = d(minIdx:end);
%     [~,maxIdx] = max(d_up);
%     d_up = d_up(1:maxIdx);
    
    d_up = d_ISI(minIdx:end);
    [~,maxIdx] = max(d_up);
    d_up = d_up(1:maxIdx);
    % calculate the ratios...
    downPhaseT_ration(i) = length(d_down)/length(d_up);
end

meanRation = mean(downPhaseT_ration);
CV = std(downPhaseT_ration)/meanRation;


end

