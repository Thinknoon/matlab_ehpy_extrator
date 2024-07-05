function [h_fig] = plotAnalysiedTrace(Attr,sweepVoltageData,totalSweeps,stim_Ind)
%可视化已经分析的trace
scrsz = get(groot,'ScreenSize');
h_fig = figure('Position',[0, 0, scrsz(3), scrsz(4)],'PaperSize', [scrsz(3), scrsz(4)], 'PaperUnits','points','Visible', 'off');
m = floor(sqrt(totalSweeps));
n = ceil(totalSweeps/m);
for sweep=1:totalSweeps
    subplot(m,n,sweep);
    plot(sweepVoltageData(:,sweep),'k');
    hold on;
    ind_thresh=Attr.APproperties(sweep).ind_threshold;
    AP_thresh =Attr.APproperties(sweep).AP_threshold;
    peak_idx = Attr.APproperties(sweep).idices;
    d_sweep = sweepVoltageData(:,sweep);
    plot(ind_thresh,AP_thresh,'go');
    plot(peak_idx,d_sweep(peak_idx),'ro');
    set(gca,'XTickLabel',[], 'YTickLabel',[]);
    set(gca, 'XLim',[0,length(d_sweep)]);
    yLim = get(gca,'yLim');
    plot([stim_Ind(1),stim_Ind(1)],yLim,'y','LineWidth',2,'LineStyle','-');
    plot([stim_Ind(2),stim_Ind(2)],yLim,'y','LineWidth',2,'LineStyle','-');
    hold off;
end

