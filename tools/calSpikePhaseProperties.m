function [ phaseTrace, phaseArea, phasePerimeter ] = calSpikePhaseProperties( d_sweep, peak_idx, sampleFrequency, isPlot)
%The function calSpikePhaseProperties plots the spike trace phases and calculates the spike pases properties.
% INPUT:
%     d - data of a sweep trace.
%     peak_idx - the position indices of the spike peaks in the sweep.
%     sampleFrequency - the sample collection points in each second of the data
%     isPlot - setting to 1 would plot the spike phase figure, otherwise not. 
%
% OUTPUT:
%     phaseTrace - the data points of the plotted figure.
%     phaseArea - the area values of the closed traces.

if isempty(peak_idx)
    phaseTrace = [];
    phaseArea = [];
    phasePerimeter = [];
    return;
end

if nargin == 2
    sampleFrequency = 50000;
    isPlot = 1;
elseif nargin ==3
    isPlot = 1;
end

% find the stimulation period.
si = 1000/sampleFrequency;
    
%calculate the dV/dt.
dd = diff(d_sweep);
dd = dd/si;

% find all spike periods. The whole segmented data trace is 250 points
% procedding the first spike peak to 250 points after the last spike peak.
% Each phase trace is from a midpoint of two adjecent peak (or the start of the segmented data trace) to the next
% midpoint (or the end of the segmented data trace).
if numel(peak_idx) == 1
    midpoint = [];
else
    for i = 1:length(peak_idx)-1
        midpoint(i) = floor( mean( peak_idx(i:i+1) ) );
    end
end
spikeCenteredRange = [peak_idx(1)-250,midpoint,peak_idx(end)+250];

% color setting
numSpikes = length(spikeCenteredRange)-1;

for i = 1:numSpikes
    % calculate the area in the closed curve.
    xx = [d_sweep(spikeCenteredRange(i):spikeCenteredRange(i+1));d_sweep(spikeCenteredRange(i))];
    yy = smooth( [dd(spikeCenteredRange(i):spikeCenteredRange(i+1)); dd(spikeCenteredRange(i))] );
    phaseArea(i) = polyarea(xx,yy);
    phaseTrace(i).mV = xx;
    phaseTrace(i).dv_dt = yy;
    phasePerimeter(i) = perimeter( alphaShape(xx(1:end-1),yy(1:end-1)) );
end

if isPlot == 1
    % plot the spike phase plane.
    color=colormap(hsv(numSpikes*2));
    for i = 1:numSpikes
        hold on;
        plot( d_sweep(spikeCenteredRange(i):spikeCenteredRange(i+1)), smooth( dd(spikeCenteredRange(i):spikeCenteredRange(i+1)), 5),'color',color(i,:))
    end
    colorbar();
    xlabel('Amplitude (mV)');
    ylabel('dV/dt (mV/ms)');
    hold off;
end







% % dummy test
% figure;
% spikesData = [peak_idx(1)-200,peak_idx(end)+200];
% for i = 1:numSpikes
%     hold on;
%     plot(d(peak_idx(i)-200:peak_idx(i)+200), smooth( dd(peak_idx(i)-200:peak_idx(i)+200), 5), 'color',color(i,:));
% end




end

