function [featureFig] = plotFeatures(Attr,sweepVoltageData,si,totalSweeps,stim_Ind,fileName)

%可视化每个细胞的电生理参数
featureFig = figure('Position',[100,100,1500,700],'visible','off');
set(gcf,'PaperOrientation','Landscape','PaperType','a4','Units','inches','PaperSize',[28,20],'PaperOrientation','landscape','PaperPositionMode','auto');
t = (1:length(sweepVoltageData))*si*1e-3;
sampleFrequency = 1e+6/si;
%%
%第一个子图
subplot(3,4,1);
plot(t,sweepVoltageData);
xLim = get(gca,'xLim');
yLim = get(gca,'yLim');
X1 = xLim(1) + diff(xLim)*0.64;
Y1 = yLim(1) + diff(yLim)*0.9;
textStr = strcat( '# of Sweeps: ',num2str(totalSweeps) );
text(X1,Y1, textStr);
str1 = char( fileName ,'All traces plotting');
title(str1);
%%
%第二个子图
subplot(3,4,2);
hold on;
plot(t,sweepVoltageData(:,1),'k');  % plot trace.
plot(t,sweepVoltageData(:,Attr.plotData.idx_sweep1),'Color',[0.4,0.4,0.4]);  % plot trace.
plot(t,sweepVoltageData(:,Attr.plotData.idx_sweep2),'Color',[0.7,0.7,0.7]);  % plot trace.
% hold on;plot(ind_threshold*si*1e-3,AP_threshold,'go');   %plot threhold point
plot( (Attr.fit1(1).idx_data(1):Attr.fit1(1).idx_data(2)-1)*si*1e-3, Attr.fit1(1).d_fit, 'r','LineStyle' , '-','LineWidth', 2 )
plot( (Attr.fit2.idx_data(1):Attr.fit2.idx_data(2)-1)*si*1e-3, Attr.fit2.d_fit, 'r','LineStyle' , '-','LineWidth', 2 )
xLim = get(gca,'xLim');
yLim = get(gca,'yLim');
plot([stim_Ind(1),stim_Ind(1)].*si.*1e-3,yLim,'y','LineWidth',2,'LineStyle','-');
plot([stim_Ind(2),stim_Ind(2)].*si.*1e-3,yLim,'y','LineWidth',2,'LineStyle','-');
title('Tau calculation');
% add the texts.
X1 = xLim(1) + diff(xLim)*0.64;
Y1 = yLim(1) + diff(yLim)*0.4;
Y2 = yLim(1) + diff(yLim)*0.5;
Y3 = yLim(1) + diff(yLim)*0.6;
Y4 = yLim(1) + diff(yLim)*0.7;
Y5 = yLim(1) + diff(yLim)*0.8;
textStr = strcat('Rheobase: ',num2str(Attr.Rheobase,'%6.2f'),'pA');
text(X1,Y1,textStr);
textStr = strcat( 'Rebound: ',num2str(Attr.rebound_mV,'%6.2f'),' mV' );
text(X1,Y2, textStr);
textStr = strcat('Max FR: ',num2str(Attr.maxFiringRate,'%6.2f'),'sp/s');
text(X1,Y3,textStr);
textStr = strcat('Sweep Nr.(max FP): ',num2str(Attr.plotData.idx_sweep2));
text(X1,Y4,textStr);
textStr = strcat('ISI adpIdx: ',num2str(Attr.ISI_adpIdx_atmaxFR,'%6.2f'));
text(X1,Y5,textStr);
hold off; 
%%
subplot(3,4,3);
hold on;
m_height=zeros(1,totalSweeps);
    for i_sweep = 1:totalSweeps
        fd = filter_butter(sweepVoltageData(:,Attr.plotData.idx_sweep1),sampleFrequency);
        %   height = max(fd)+20;
        height =  max(fd) + 15;
        if height > -10
            height = max(fd) + 15;
        else
            height = -10;
        end
        m_height(i_sweep) = height;
    end
if ~isempty(Attr.plotData.idx_sweep1)
    plot(t,sweepVoltageData(:,Attr.plotData.idx_sweep1),'k');
    [~,peak_idx_tem] = findSpikes(sweepVoltageData(:,Attr.plotData.idx_sweep1),m_height(Attr.plotData.idx_sweep1) );
    ind_threshold = Attr.APproperties(Attr.plotData.idx_sweep1).ind_threshold(1);
    AP_threshold = Attr.APproperties(Attr.plotData.idx_sweep1).AP_threshold(1);
    plot(ind_threshold.*si.*0.001,AP_threshold,'go');
    plot(peak_idx_tem(1).*si.*0.001,sweepVoltageData(peak_idx_tem(1),Attr.plotData.idx_sweep1),'ro');
else
    plot(sweepVoltageData(:,1));
    text(1, 0,'No any spike within stim peroid of any sweep!');
end
fd = smooth(fd(round(length(fd)*0.1):end),1000);
plot([t(1),t(end)],[m_height(Attr.plotData.idx_sweep1) , m_height(Attr.plotData.idx_sweep1) ],'r');
xLim = get(gca,'xLim');
yLim = get(gca,'yLim');
plot([stim_Ind(1),stim_Ind(1)].*si.*0.001,yLim,'y','LineWidth',2,'LineStyle','-');
plot([stim_Ind(2),stim_Ind(2)].*si.*0.001,yLim,'y','LineWidth',2,'LineStyle','-');
title('AP properties calculation');
% add the texts.
X1 = xLim(1) + diff(xLim)*0.63;
Y1 = yLim(1) + diff(yLim)*0.9;
Y2 = yLim(1) + diff(yLim)*0.8;
Y3 = yLim(1) + diff(yLim)*0.7;
str_tem = strcat('Sweep Nr.: ', num2str(Attr.plotData.idx_sweep1));
text(X1,Y1,str_tem);
str_tem = strcat('Thresh: ', num2str(Attr.threshold,'%6.2f'),'mV');
text(X1,Y2,str_tem);
str_tem = strcat('AP-Amp: ', num2str(Attr.AP_Amp,'%6.2f'),'mV');
text(X1,Y3,str_tem);
hold off;
%%
subplot(3,4,4);
t = (1:length(sweepVoltageData))*si*1e-3;
hold on;
for i = 1:length(Attr.fit1)
    plot(t,sweepVoltageData(:,i),'k');  % plot trace.
    plot( (Attr.fit1(i).idx_data(1):Attr.fit1(i).idx_data(2)-1)*si*1e-3, Attr.fit1(i).d_fit, 'r','LineStyle' , '-','LineWidth', 2 )
end
plot( (Attr.fit2.idx_data(1):Attr.fit2.idx_data(2)-1)*si*1e-3, Attr.fit2.d_fit, 'r','LineStyle' , '-','LineWidth', 2 )
xLim = get(gca,'xLim');
yLim = get(gca,'yLim');
plot([stim_Ind(1),stim_Ind(1)].*si.*1e-3,yLim,'y','LineWidth',2,'LineStyle','-');
plot([stim_Ind(2),stim_Ind(2)].*si.*1e-3,yLim,'y','LineWidth',2,'LineStyle','-');
title('Tau calculation');
% add the texts.
X1 = xLim(1) + diff(xLim)*0.66;
Y1 = yLim(1) + diff(yLim)*0.85;
Y2 = yLim(1) + diff(yLim)*0.75;
Y3 = yLim(1) + diff(yLim)*0.65;
Y4 = yLim(1) + diff(yLim)*0.55;
text(X1,Y1,'Sweep Nr.: 1');
%这里仅仅展示tau前5个的中位数
Tau=median(Attr.tau(1:5));
str_tem = strcat('Tau: ', num2str(Tau));
text(X1,Y2,str_tem);
textStr = strcat( 'Rebound: ',num2str(Attr.rebound_mV,'%6.2f'),' mV' );
text(X1,Y3, textStr);
%这里只plot第一条刺激的reboundSpike
reboundSpike = Attr.reboundSpikeCount(1);
textStr = strcat( 'nReboundSpikes: ',num2str(reboundSpike,'%d'));
text(X1,Y4, textStr);
hold off;
%%
subplot(3,4,5);
hold on;
%提取AHP_sweep
AHP_sweep = Attr.plotData.AHP_sweep;
AHP_idx = Attr.plotData.AHP_idx;
ADP_value = Attr.ADP_value;
ADP_sweep = Attr.plotData.ADP_sweep;
ADP_idx = Attr.plotData.ADP_idx;
if ~isempty(AHP_sweep)
    plot(t,sweepVoltageData(:,AHP_sweep));
    fd = filter_butter(sweepVoltageData(:,AHP_sweep),sampleFrequency);
    fd = smooth(fd(round(length(fd)*0.1):end),1000);
    height = m_height(AHP_sweep);
    plot([t(1),t(end)],[height, height],'r');
    plot(Attr.APproperties(AHP_sweep).ind_threshold(1).*si.*0.001,Attr.APproperties(AHP_sweep).AP_threshold(1),'go');
    [~,peak_idx_tem] = findSpikes(sweepVoltageData(:,AHP_sweep),height);
    plot(peak_idx_tem(1).*si.*0.001,sweepVoltageData(peak_idx_tem(1),AHP_sweep),'ro');
    if ~isnan(Attr.AHP_value)
        plot(AHP_idx.*si.*0.001,sweepVoltageData(AHP_idx ,AHP_sweep),'ko');
    end
    plot(AHP_idx.*si.*0.001,sweepVoltageData(AHP_idx ,AHP_sweep),'ko');
    if ~isnan(ADP_value)
        plot(ADP_idx.*si.*0.001,sweepVoltageData(ADP_idx ,ADP_sweep),'bo');
    end
    xlim([peak_idx_tem(1)-200  peak_idx_tem(1)+600]*si.*0.001 )
    ylim([-70   80])
    
    xLim = get(gca,'xLim');
    yLim = get(gca,'yLim');
    plot([stim_Ind(1),stim_Ind(1)].*si.*0.001,yLim,'y','LineWidth',2,'LineStyle','-');
    plot([stim_Ind(2),stim_Ind(2)].*si.*0.001,yLim,'y','LineWidth',2,'LineStyle','-');
    title('AHP calculation');
    % add the texts.
    X1 = xLim(1) + diff(xLim)*0.63;
    Y1 = yLim(1) + diff(yLim)*0.9;
    Y2 = yLim(1) + diff(yLim)*0.8;
    Y3 = yLim(1) + diff(yLim)*0.7;
    Y4 = yLim(1) + diff(yLim)*0.6;
    str_tem = strcat('Sweep Nr.: ', num2str(AHP_sweep));
    text(X1,Y1,str_tem);
    str_tem = strcat('halfAPwidth: ', num2str(Attr.halfAPwidth,'%6.2f'),'ms');
    text(X1,Y2,str_tem);
    str_tem = strcat('AHP: ', num2str(Attr.AHP_value,'%6.2f'),' mV');
    text(X1,Y3,str_tem);
    if ~isnan(ADP_value)
        str_tem = strcat('ADP: ', num2str(ADP_value,'%6.2f'),' mV');
        text(X1,Y4,str_tem);
    end
    xlabel('Time (ms)');
    ylabel('Membrane potential (mV)');
    hold off;
else
    xLim = get(gca,'xLim');
    yLim = get(gca,'yLim');
    X1 = xLim(1) + diff(xLim)*0.3;
    Y1 = yLim(1) + diff(yLim)*0.6;
    text(X1,Y1,'AHP = NaN');
end
%%
subplot(3,4,6);
hold on;
idx_sweep2=Attr.plotData.idx_sweep2;
if ~isempty(idx_sweep2)
    plot(t, sweepVoltageData(:,idx_sweep2),'k');
    fd = filter_butter(sweepVoltageData(:,idx_sweep2),sampleFrequency);
    fd = smooth(fd(round(length(fd)*0.1):end),1000);
    
    %             height =  max(fd) + 15;
    %             if height > -10
    %                    height = max(fd) + 15;
    %             else
    %                  height = -10
    %             end
    %
    height = m_height(idx_sweep2);
    plot([t(1),t(end)],[height, height],'r');
    plot(Attr.APproperties(idx_sweep2).ind_threshold.*si.*0.001,Attr.APproperties(idx_sweep2).AP_threshold,'go');
    [~,peak_idx_tem] = findSpikes(sweepVoltageData(:,idx_sweep2),height);
    plot(peak_idx_tem.*si.*0.001,sweepVoltageData(peak_idx_tem,idx_sweep2),'ro');
    xLim = get(gca,'xLim');
    yLim = get(gca,'yLim');
    plot([stim_Ind(1),stim_Ind(1)].*si.*0.001,yLim,'y','LineWidth',2,'LineStyle','-');
    plot([stim_Ind(2),stim_Ind(2)].*si.*0.001,yLim,'y','LineWidth',2,'LineStyle','-');
    title('Adaption index calculation');
    % add the texts.
    X1 = xLim(1) + diff(xLim)*0.63;
    Y1 = yLim(1) + diff(yLim)*0.9;
    Y2 = yLim(1) + diff(yLim)*0.8;
    Y3 = yLim(1) + diff(yLim)*0.7;
    Y4 = yLim(1) + diff(yLim)*0.6;
    str_tem = strcat('Sweep Nr.: ', num2str(idx_sweep2));
    text(X1,Y1,str_tem);
    str_tem = strcat('Max FR.: ', num2str(Attr.maxFiringRate,'%6.2f'),'spikes/s');
    text(X1,Y2,str_tem);
    str_tem = strcat('ISI phaseT ratio: ', num2str(Attr.ISI_phaseT_ratio,'%6.2f'));
    text(X1,Y3,str_tem);
    str_tem = strcat('ISI phaseT ratio CV: ', num2str(Attr.ISI_phaseT_ratio_CV,'%6.2f'));
    text(X1,Y4,str_tem);
    hold off;
end
        
% plot the first spike and zoom in to show the properties in tail.
subplot(3,4,7);
hold on;
idx_sweep1=Attr.plotData.idx_sweep1;
peakIdx = Attr.APproperties(idx_sweep1).idices(1);
d_tem = sweepVoltageData( (peakIdx-5*1000/si):(peakIdx+15*1000/si),idx_sweep1) ;
t_tem = ( ( 1:length(d_tem) )+peakIdx-5*1000/si ).*si*0.001;
plot(t_tem, d_tem,'k');
% plot the important points...
thresh_idx = Attr.APproperties(idx_sweep1).ind_threshold(1);
thresh_value = Attr.APproperties(idx_sweep1).AP_threshold(1);
plot(thresh_idx*si*0.001,thresh_value,'go');     % circle the threshold point.
peak_value = Attr.APproperties(idx_sweep1).peaks(1);
plot(peakIdx*si*0.001,peak_value,'ro');     % circle the AP peak point.
% get axes limitation and prepared for next steps.
xLim = get(gca,'xlim');
yLim = get(gca,'ylim');
% adding the arrow to indicate the AP amplitude.
axPos = get(gca,'position');
Y_convAmp(1) = axPos(2)+axPos(4)/diff(yLim)*(thresh_value-yLim(1));
Y_convAmp(2) = axPos(2)+axPos(4)/diff(yLim)*(peak_value-yLim(1));
% adding the arrow indicating the AP width.
halfAPposition = (thresh_value+peak_value)/2;
leftArm = d_tem(1:(5*1000/int16(si)));
Xwidth1 = ( find(leftArm<halfAPposition,1,'last')+(peakIdx-5*1000/si) )*si*0.001;
APwidth = Attr.APproperties(idx_sweep1).halfHeightWidth(1);
Xwidth2 = Xwidth1+APwidth;
X_convWidth(1) = axPos(1)+axPos(3)/diff(xLim)*(Xwidth1-xLim(1));
X_convWidth(2) = axPos(1)+axPos(3)/diff(xLim)*(Xwidth2-xLim(1));
Y_convWidth(1) = Y_convAmp(1)+diff(Y_convAmp)/2;
Y_convWidth(2) = Y_convWidth(1);
annotation('doublearrow', X_convWidth, Y_convWidth,'color','k','headStyle','Plain','Head1Length',3,'Head2Length',3,'Head1Width',3,'Head2Width',3);
text( Xwidth1, thresh_value+(peak_value-thresh_value)/2-10,'Width');
% adding the vertical lines to indicate the rising time and decay
% time.
rightArm = d_tem(5*1000/int16(si):end);
rightArmTop = peak_value;
XrightArmIdx = (peakIdx+find(rightArm<thresh_value,1,'first'));
if isempty(XrightArmIdx)  % when XrightArmIdx is empty, set the variable to a new value to plot the double arrows and text boxes.
    XrightArmIdx = (Xwidth1+2*APwidth)*1000/si;
end
line( [ thresh_idx,peakIdx,XrightArmIdx; thresh_idx,peakIdx,XrightArmIdx]*si*0.001,[rightArmTop,rightArmTop,rightArmTop;thresh_value,thresh_value,thresh_value ],'color',[0.5,0.5,0.5] );
% adding the arrow to indicate the AP amplitude.
X_convAmp(1) = axPos(1)+axPos(3)/diff(xLim)*((XrightArmIdx+70)*si*0.001-xLim(1));
X_convAmp(2) = X_convAmp(1);
annotation('doublearrow', X_convAmp, Y_convAmp,'color','k','headStyle','Plain','Head1Length',3,'Head2Length',3,'Head1Width',3,'Head2Width',3);
t=text( (XrightArmIdx+100)*si*0.001, 20+yLim(1)+diff(yLim)/2,'Amplitude');
t.Rotation = -90;
% plot thehorizontal broken lines.
line([ thresh_idx, peakIdx; XrightArmIdx+(xLim(2)*1000/si-XrightArmIdx)/2, XrightArmIdx+(xLim(2)*1000/si-XrightArmIdx)/4].*si*0.001, [thresh_value, peak_value;thresh_value, peak_value],'LineStyle','--','color','k','lineWidth',1.0);
% adding the double arrow to idicate the rising time
X_convRising(1) = axPos(1)+axPos(3)/diff(xLim)*(thresh_idx*si*0.001-xLim(1));
X_convRising(2) = axPos(1)+axPos(3)/diff(xLim)*(peakIdx*si*0.001-xLim(1));
Y_convRising(1) = Y_convAmp(1)+diff(Y_convAmp)*3/4;
Y_convRising(2) = Y_convRising(1);
annotation('doublearrow', X_convRising, Y_convRising,'color','k','headStyle','Plain','Head1Length',3,'Head2Length',3,'Head1Width',3,'Head2Width',3);
t=text( (thresh_idx-70)*si*0.001, yLim(1)+diff(yLim)*4/5,'RisingT');
t.Rotation = -90;
if XrightArmIdx ~= (Xwidth1+2*APwidth)*1000/si  % means actually XrightArmIdx is empty and downward spike decay phase has no intersection with threshold value.
    % adding the double arrow t indicate the decay time.
    X_convDecay(1) = axPos(1)+axPos(3)/diff(xLim)*(peakIdx*si*0.001-xLim(1));
    X_convDecay(2) = axPos(1)+axPos(3)/diff(xLim)*(XrightArmIdx*si*0.001-xLim(1));
    Y_convDecay(1) = Y_convAmp(1)+diff(Y_convAmp)*1/4;
    Y_convDecay(2) = Y_convDecay(1);
    annotation('doublearrow', X_convDecay, Y_convDecay,'color','k','headStyle','Plain','Head1Length',3,'Head2Length',3,'Head1Width',3,'Head2Width',3);
    t=text( (peakIdx+10)*si*0.001, thresh_value(1)+diff(yLim)/8,'DecayT');
end
% add the text of 'Threshold'.
text( (XrightArmIdx+(xLim(2)*1000/si-XrightArmIdx)/4)*si*0.001, thresh_value+5,'Threshold');
title('Sketch of AP related paramters');
hold off;
%%
subplot(3,4,8);
hold on;
idx_sweep2=Attr.plotData.idx_sweep2;
stimLevels_latency=Attr.plotData.stimLevels_latency;
latencies = Attr.plotData.latencies;
P_latency=Attr.plotData.P_latency;
if ~isempty(idx_sweep2) && sum(~isnan(Attr.plotData.late_spikingT) ) >= 5
    plot(stimLevels_latency, 1./latencies,'k','marker','o','markerFace','k','markerSize',5,'LineStyle','none');
    plot(stimLevels_latency,P_latency(1).*stimLevels_latency+P_latency(2),'k-','lineWidth',1.2);
    xlabel('Current (pA)');
    ylabel('Reciprocal of AP latency (1/ms)');
    xLim = get(gca,'xLim');
    yLim = get(gca,'yLim');
    set(gca,'xlim',[xLim(1)*0.8,xLim(2)*1.2],'ylim',[0,yLim(2)*1.5]);
    xLim = get(gca,'xLim');
    yLim = get(gca,'yLim');
    X1 = xLim(1) + diff(xLim)*0.1;
    Y1 = yLim(1) + diff(yLim)*0.9;
    str_tem = strcat('Fitting slope.: ', num2str(P_latency(1),'%6.4f'));
    text(X1,Y1,str_tem);
else
    xLim = get(gca,'xLim');
    yLim = get(gca,'yLim');
    text(xLim(1)+diff(xLim)/2, diff(yLim)/2, 'Fitting slope: NaN');
end
title('AP latencies (reciprocal) relative to input current');

subplot(3,4,9);
hold on;
m_stilevel = Attr.plotData.m_stilevel;
stimLevels_FR = Attr.plotData.stimLevels_FR;
P_FR = Attr.plotData.P_FR;
FR = Attr.plotData.FR;
m_FRP = Attr.plotData.m_FRP;
m_FR = Attr.plotData.m_FR;
m_FR_slope = Attr.m_FR_slope;
if length(FR)>=5
    plot(stimLevels_FR, FR(1:5),'k','marker','o','markerFace','k','markerSize',5,'LineStyle','none');
    plot(stimLevels_FR,P_FR(1).*stimLevels_FR+P_FR(2),'k-','lineWidth',2);
    
    plot(m_stilevel, m_FR,'b','marker','o','markerFace','b','markerSize',5,'LineStyle','none');
    plot(m_stilevel, m_FR_slope(1).*m_stilevel+m_FRP(2),'b-','lineWidth',2);
    
    xlabel('Current (pA)');
    ylabel('Firing rate (spikes/m)')
    xLim = get(gca,'xLim');
    yLim = get(gca,'yLim');
    set(gca,'xlim',[xLim(1)*0.8,xLim(2)*1.2],'ylim',[0,yLim(2)*1.5]);
    X1 = xLim(1) + diff(xLim)*0.23;
    Y1 = yLim(1) + diff(yLim)*0.9;
    str_tem = strcat('Slope.: ', num2str(P_FR(1),'%6.4f'));
    text(X1,Y1,str_tem);
    Y1 = yLim(1) + diff(yLim)*1.05;
    str_tem = strcat('new Slope.: ', num2str(m_FR_slope(1),'%6.4f'));
    
    
    text(X1,Y1,str_tem);
else
    xLim = get(gca,'xLim');
    yLim = get(gca,'yLim');
    text(xLim(1)+diff(xLim)/2, diff(yLim)/2, 'Fitting slope: NaN');
end
title('Firing rates relative to input current');

%%        
subplot(3,4,10);
hold on;
%load data from Attr
idx_sweep2=Attr.plotData.idx_sweep2;
idx_sweep1=Attr.plotData.idx_sweep1;
stimLevels_1stISI=Attr.plotData.stimLevels_1stISI;
firstISI=Attr.plotData.firstISI;
P_1stISI=Attr.plotData.P_1stISI;
m_stimLevels_1stISI=Attr.plotData.m_stimLevels_1stISI;
m_P_1stISI=Attr.plotData.m_P_1stISI;
m_firstISI = Attr.plotData.m_firstISI;
%plot
if length(firstISI(~isnan(firstISI)))>=5 && idx_sweep2-idx_sweep1>=4
    plot(stimLevels_1stISI, firstISI(1:5),'k','marker','o','markerFace','k','markerSize',5,'LineStyle','none');
    plot(stimLevels_1stISI,P_1stISI(1).*stimLevels_1stISI+P_1stISI(2),'k-','lineWidth',1.2);
    
    if length(m_stimLevels_1stISI) >= 5
        plot(m_stimLevels_1stISI, m_firstISI,'k','marker','o','markerFace','b','markerSize',5,'LineStyle','none');
        plot(m_stimLevels_1stISI, m_P_1stISI(1).*m_stimLevels_1stISI+m_P_1stISI(2),'b-','lineWidth',1.2);
    end
    xlabel('Current (pA)');
    ylabel('Fist ISI in sweeps (ms)')
    xLim = get(gca,'xLim');
    yLim = get(gca,'yLim');
    set(gca,'xlim',[xLim(1)*0.8,xLim(2)*1.2],'ylim',[0,yLim(2)*1.5]);
    X1 = xLim(1) + diff(xLim)*0.63;
    Y1 = yLim(1) + diff(yLim)*0.9;
    str_tem = strcat('Slope.: ', num2str(P_1stISI(1),'%6.4f'));
    text(X1,Y1,str_tem);
    Y1 = yLim(1) + diff(yLim)*1.05;
    str_tem = strcat('new Slope.: ', num2str(m_P_1stISI(1),'%6.4f'));
    text(X1,Y1,str_tem);
    
else
    xLim = get(gca,'xLim');
    yLim = get(gca,'yLim');
    text(xLim(1)+diff(xLim)/2, diff(yLim)/2, 'Fitting slope: NaN');
end
title('First ISI relative to input current');

%%        
subplot(3,4,11);
hold on;
%load data
idx_sweep2=Attr.plotData.idx_sweep2;
stimLevels_adpIdx_initial = Attr.plotData.stimLevels_adpIdx_initial;
ind_adpIdx = Attr.plotData.ind_adpIdx;
stimLevels_adpIdx = Attr.plotData.stimLevels_adpIdx;
P_ISIadpIdx = Attr.plotData.P_ISIadpIdx;
ISI_adpIdx_initial = Attr.plotData.ISI_adpIdx_initial;
P_ISIadpIdx_slope_inital = Attr.plotData.P_ISIadpIdx_slope_inital;
ISI_adpIdx = Attr.plotData.ISI_adpIdx;
if ~isempty(idx_sweep2) && ~isempty(ind_adpIdx)
    plot(stimLevels_adpIdx, ISI_adpIdx(ind_adpIdx),'k','marker','o','markerFace','k','markerSize',5,'LineStyle','none');
    plot(stimLevels_adpIdx,P_ISIadpIdx(1).*stimLevels_adpIdx+P_ISIadpIdx(2),'k-','lineWidth',1.2);
    
    plot(stimLevels_adpIdx_initial, ISI_adpIdx_initial,'k','marker','o','markerFace','b','markerSize',5,'LineStyle','none');
    plot(stimLevels_adpIdx_initial,P_ISIadpIdx_slope_inital(1).*stimLevels_adpIdx_initial+P_ISIadpIdx_slope_inital(2),'b-','lineWidth',1.2);
    
    xlabel('Current (nA)');
    ylabel('ISI adapt idx')
    xLim = get(gca,'xLim');
    yLim = get(gca,'yLim');
    set(gca,'xlim',[xLim(1)*0.8,xLim(2)*1.2],'ylim',[0,yLim(2)*1.5]);
    X1 = xLim(1) + diff(xLim)*0.63;
    Y1 = yLim(1) + diff(yLim)*0.9;
    str_tem = strcat('Slope.: ', num2str(P_ISIadpIdx(1),'%6.4f'));
    text(X1,Y1,str_tem);
    Y1 = yLim(1) + diff(yLim)*1.05;
    str_tem = strcat('New Slope.: ', num2str( P_ISIadpIdx_slope_inital(1),'%6.4f'));
    text(X1,Y1,str_tem);
else
    xLim = get(gca,'xLim');
    yLim = get(gca,'yLim');
    text(xLim(1)+diff(xLim)/2, diff(yLim)/2, 'Fitting slope: NaN');
end
title('ISI adpIdx relative to input current');

%%
subplot(3,4,12);
hold on;
firstAmpAdpIdx_select = Attr.plotData.firstAmpAdpIdx_select;
P_ampAdaptIdx = Attr.plotData.P_ampAdaptIdx;
m_P_ampAdaptIdx = Attr.plotData.m_P_ampAdaptIdx;
stimLevels_ampAdpIdx = Attr.plotData.stimLevels_ampAdpIdx;

if length(firstAmpAdpIdx_select(~isnan(firstAmpAdpIdx_select)))>=5
    plot(stimLevels_ampAdpIdx, firstAmpAdpIdx_select,'b','marker','o','markerFace','k','markerSize',5,'LineStyle','none');
    plot(stimLevels_ampAdpIdx(1:5),P_ampAdaptIdx(1).*stimLevels_ampAdpIdx(1:5)+P_ampAdaptIdx(2),'k-','lineWidth',1.2);
    plot(stimLevels_ampAdpIdx,m_P_ampAdaptIdx(1).*stimLevels_ampAdpIdx+m_P_ampAdaptIdx(2),'b-','lineWidth',1.2);
    xlabel('Current (nA)');
    ylabel('amp adapt index in sweeps (ms)')
    xLim = get(gca,'xLim');
    yLim = get(gca,'yLim');
    set(gca,'xlim',[xLim(1)*0.8,xLim(2)*1.2],'ylim',[0,yLim(2)*1.5]);
    X1 = xLim(1) + diff(xLim)*0.63;
    Y1 = yLim(1) + diff(yLim)*0.9;
    str_tem = strcat('Slope.: ', num2str(P_ampAdaptIdx(1),'%6.4f'));
    text(X1,Y1,str_tem);
    Y1 = yLim(1) + diff(yLim)*1.1;
    str_tem = strcat('New Slope.: ', num2str(m_P_ampAdaptIdx(1),'%6.4f'));
    text(X1,Y1,str_tem);
else
    xLim = get(gca,'xLim');
    yLim = get(gca,'yLim');
    text(xLim(1)+diff(xLim)/2, diff(yLim)/2, 'Fitting slope: NaN');
end
title('Amp adpIdx relative to input current');
    



end

