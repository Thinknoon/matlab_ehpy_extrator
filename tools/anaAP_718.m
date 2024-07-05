function [ peak_idx, AP_thresh,ind_thresh,AP_amp, halfHeightWidth, AP_rise_t,AP_decay_t, stroke , APHeight ] = anaAP_718( d, stim_Ind,si )
%ANAAP find and analyzes the action potentials in a sweep trace.
%  anaAP analyzes the action potentials of a sweep trace. The input
%     variblesare following:
% INPUT:
%     d - 2 dimentional data array of single channel patch-clamp recording 
%         data. 1-d is single sweep data, and 2-d is sweeps. For example: 
%         array 'd', size(d) is (55000,50). The 'd' contains 50 sweeps of 
%         data traces.
%     stim_Ind - (optional) an 2-element array, defines the indices of 
%         stimulation start and stop.
%     si - (optional) sample interval, unit: uS. For example, si =20, we can calculate
%         the sample frequency is  sampleFrequency = 10e+5/si, because
%         sampleFrequency * si = 1 sec.
% OUTPUT:
%     peak_idx - the positions (indices) of action potential peaks.
%     AP_thresh - an array contains thresholds of action potentials.
%     ind_thresh - the indices of action potentials thresholds.
%     AP_amp - amplitudes of action potentials.
%     halfHeightWidth - half-height-half-wave widthes of action potentials.
%     AP_rise_t - times of rising slope of action potentials.     
%     AP_decay_t - times of decay slope of action potentials.
% 
% EXAMPLE:
%     [ peak_idx, AP_thresh,ind_thresh,AP_amp, halfHeightWidth, AP_rise_t,AP_decay_t ] = anaAP( d_sweep, [2500,17500],20 );
%
% Coded by Dr. Ruifeng Liu  (Zhongshan Ophthalmic Center, Sun Yat-sen
%     University) on Oct 2019.

AP_decay_t = [];
sampleFrequency = 1e+6/si;

% get the third derivative values to parepare for thresholds searching.
% dd=smooth(diff(d), 5); % smooth first and get the first derivative of the curve.
dd=[0; filter_3000Lowpass(diff(d),sampleFrequency)]; % get the second derivative and smooth it.
ddd =[0; filter_3000Lowpass(diff(dd),sampleFrequency)];  % get the third derivative and smooth it.

% dd=   medfilt1(diff(dd),3); % get the second derivative and smooth it.
% dd = medfilt1(diff(dd), 3);  % get the third derivative and smooth it.

% Automatically determine the parameter height (threshold to distinguish the spikes)
fd = filter_butter(d,sampleFrequency);
fd = smooth(fd(round(length(fd)*0.1):end),1001);
height =  max(fd) + 15;
if height < -10
    height = -10;
else
    height =  max(fd) + 15;
    [count1 ,peak_idx1] = findSpikes(d,height,stim_Ind);
    height  = (mean(d(peak_idx1)) +  max(fd))/2;
end


clear fd;
% find spikes. The following function returns the number of dpikes detected and the locations (indices in data array) of spike peaks.

[count ,peak_idx] = findSpikes(d,height,stim_Ind);

%   determine
%   dt: sampling interval in seconds
%   Fc: cut-off frequency for low pass filtering, default value is 5000 Hz
%   win: the half-window size in data points around the spike to show, default is
%   200 points.
%   win2: the window from the peak backwards in time in which the threshold
%   is found. Default value is 100 datapoints
%   factordvdt: is the factor times the max derivative in Vm, as a minimum to
%   include in the analysis. This is to limit the divergent data points.
%   Default is 0.03
[mean_thresh sd_thresh N thresvalue thres_coords_orginal]  =  Spike_threshold_PS3(d,  1/sampleFrequency, 120, 60, 3000,  0.03, height, stim_Ind);
AP_thresh =  thresvalue;
ind_thresh = thres_coords_orginal;

if length(thresvalue) == 0
    count = 0;
    peak_idx = [];
end

if count ~= 0
    % get the threshold of the current spike.
    leftArm = [];rightArm = [];
    leftboarder = [];
    for i = 1:count
        % segment the data. The data within the stim peroid was divided into
        % many segmentations according to action potentials. All segmentation
        % was aligned with action potential peaks.The data before peaks are
        % leftArms, while data after peaks are rightArms. The indices of the
        % first data points of segmentations were defined as 'leftBoarder'.
        if i == 1
            leftboarder = floor( ( stim_Ind(1) + peak_idx(i) )/2 );
            leftArm = d( leftboarder:peak_idx(i));
            leftArm_dd = dd( leftboarder:peak_idx(i));
            leftArm_ddd = ddd( leftboarder:peak_idx(i));
            if count == 1
                rightArm = d(peak_idx(i):stim_Ind(2));
                rightArm_dd = dd(peak_idx(i):stim_Ind(2));
            else
                rightArm = d( peak_idx(i):floor( (peak_idx(i)+peak_idx(i+1))/2 ) );
                rightArm_dd = dd( peak_idx(i):floor( (peak_idx(i)+peak_idx(i+1))/2 ) );

            end
        elseif i == count
            leftboarder = floor( (peak_idx(i-1)+peak_idx(i))/2 );
            %         if d(leftboarder) > AP_threshold    % debugging for a situation that the following spike with a longer rise slope than half peak-peak distance.
            %             [~,min_idx] = min( d(peak_idx(i-1):peak_idx(i)) );
            %             leftboarder = min_idx ;
            %         end
            leftArm = d( leftboarder:peak_idx(i) );
            leftArm_dd = dd(leftboarder:peak_idx(i));
            leftArm_ddd = ddd(leftboarder:peak_idx(i));
            rightArm = d(peak_idx(i):stim_Ind(2));
            rightArm_d = dd(peak_idx(i):stim_Ind(2));
        else
            leftboarder = floor( (peak_idx(i-1)+peak_idx(i))/2 );
            %         if d(leftboarder) > AP_threshold    % debugging for a situation that the following spike with a longer rise slope than half peak-peak distance.
            %             [~,min_idx] = min( d(peak_idx(i-1):peak_idx(i)) );
            %             leftboarder = min_idx+peak_idx(i-1)-1;
            %         end
            leftArm = d( leftboarder:peak_idx(i) );
            leftArm_dd = dd( leftboarder:peak_idx(i) );
            leftArm_ddd = ddd( leftboarder:peak_idx(i) );
            rightArm = d( peak_idx(i):floor( (peak_idx(i)+peak_idx(i+1))/2 ) );
            rightArm_d = dd( peak_idx(i):floor( (peak_idx(i)+peak_idx(i+1))/2 ) );

        end
        %calculate the threshold for each action potential.
%         d_tem = leftArm;
%         d_tem = smooth(d_tem, 5);
%         dd=diff(d_tem); % smooth the curve of first derivative.
%         %     [~,idx_tem] = max(dd);
%         %     dd = dd(1:idx_tem);   % remove the parts of data after the first derivative peak to avoid wrong peak in the next steps.
%         ddd=filter_1000Lowpass(diff(dd),sampleFrequency); % get the second derivative and smooth it.
%         dddd = filter_1000Lowpass(diff(ddd),sampleFrequency);  % get the third derivative and smooth it.
        [~, idx] = max( leftArm_ddd );   % get the threshold position in the current data segment.
        if length(leftArm_ddd)-idx<3 % sometimes, the maximal third deveation value is the peak! If so, excludes it.
            [~, idx] = max( leftArm_ddd(1:end-4) );
        end
        
        % get the threshold values.
%         AP_thresh(i) = leftArm(idx);
        % get threshold x position.
%         ind_thresh(i) = idx+leftboarder-1;% get the threshold position in the whole data trace.
        % get the spike amplitute.
%         [up, upind] = max(dd);
        try,
     
        AP_amp(i) = d(peak_idx(i))-AP_thresh(i);
        
        catch,
           xx = 0; 
        end
      
        upstroke(i,1) =   max(leftArm_dd);    
        downstroke(i,1) =   abs(min(rightArm_dd)); 
        strokeratio(i,1) =  abs( upstroke(i) / downstroke(i) )
        APHeight(i) =  d(peak_idx(i)) -  min(rightArm);
        % get action potential half-height-half width.
        halfAPposition = (AP_thresh(i)+d(peak_idx(i)))/2;
        halfWidth_tem = length(leftArm)-find(leftArm<halfAPposition,1,'last')+find(rightArm>halfAPposition,1,'last');
        

        halfHeightWidth(i) = halfWidth_tem*si*1e-03;
        
     
    
        % get the Action Potential rise slope time range.
        AP_rise_t(i) = ( peak_idx(i)-ind_thresh(i) )*si*1e-3;
        location2 = find(rightArm < AP_thresh(i),1,'first');
        if ~isempty(location2)
            AP_decay_t(i) = location2*si*1e-3;
        else
            AP_decay_t(i) = nan;
        end
        clear idx_tem   
    end
else
    AP_thresh = [];
    ind_thresh = [];
    AP_amp = [];
    halfHeightWidth = [];
    AP_rise_t = [];
    AP_decay_t = [];
    upstroke =   [];    
    downstroke =   []; 
    strokeratio =  [];
    APHeight  = [];
end

stroke = [upstroke downstroke strokeratio];








end

