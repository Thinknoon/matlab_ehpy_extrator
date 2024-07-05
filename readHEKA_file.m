function readHEKA_file(filename, m_Path, m_chan,savePath)
clear('chan*');
clear('head*');
clear('FileSource');

%% set a temp folder to store raw .mat from function ImportHEKA
tempFolder = '.\temp\';
if ~exist(tempFolder,'dir')
    mkdir(tempFolder);
end   
fprintf('Extracting data from %s ...\n',filename);
%% ImortHEKA will write a new mat file
ImportHEKA(fullfile(m_Path,filename),tempFolder);
if exist( fullfile( tempFolder, strcat(filename(1:end-4), '.mat') ),'file' )
    load(strcat(fullfile( tempFolder, filename(1:end-4)),  '.mat'))
else
    fprintf('Failed to find MAT file \n');
    return;
end

%% deal the raw mat file
    %% add stimulation from original 
sti =  readStimulation(m_FP,fullfile(m_Path,filename));



%% select channels.
m_channel_sel = cell(1:5);

m_channel_sel2  =  zeros(1, m_chan);
m_diff = zeros(m_chan, 1);
m_totalchan = length(who('chan*'));
for jjj =  1 : m_totalchan
    for ii = 1 : m_chan
        clear alldt dt  tmpdt;
        tmpdt = ['head'  num2str(jjj)];
        eval(['dt_head =' tmpdt ';']);
        if  ~contains(lower(dt_head.Group.Label),  'fp')
            continue;
        end
        cellindex = strfind(lower(dt_head.Group.Label), 'cell');
        fpindex = strfind(lower(dt_head.Group.Label), 'fp');
        if str2num(strtrim(dt_head.Group.Label(cellindex(1)+4 : fpindex(1)-1  ) ) )  ~=  ii
            continue;
        end
        
        tmpselchan = rem(jjj, m_chan);
        if tmpselchan == 0
            tmpselchan = m_chan;
        end
        
        if   str2num(strtrim(dt_head.Group.Label(cellindex(1)+4 : fpindex(1)-1)))  ==   tmpselchan
            m_channel_sel{ii}(end+1) =  jjj;
        end
        
        tmpdt = ['chan'  num2str(jjj)];
        eval(['dt_struct =' tmpdt ';']);
        dt = dt_struct.adc;
        if size(dt, 2) < 10
            continue;
        end
        alldt(1,:) = double(dt(:,1)')*dt_head.adc.Scale+dt_head.adc.DC;
        alldt(2,:) = double(dt(:,end)')*dt_head.adc.Scale+dt_head.adc.DC;
        if  m_diff(ii) <  sum(abs(smooth(alldt(1,:), 1000) - smooth(alldt(2,:), 1000)));
            m_diff(ii) = sum(abs(smooth(alldt(1,:), 1000) - smooth(alldt(2,:), 1000)));
            m_channel_sel2(ii) = jjj;
        end
    end
end


index = 1;
ftotaltime =  (chan1.tim(1,2) - chan1.tim(1,1))*head1.tim.Scale;
fsample = (size(chan1.adc,1)-1)/ftotaltime;
m_FP.ftotaltime = ftotaltime;
m_FP.fsample = fsample;
for ii = 1 : m_chan
    if m_channel_sel2(ii)  == 0 
        continue;
    end  
    clear alldt;
    tmpdt = ['chan'  num2str( m_channel_sel2(ii))];
    eval(['dt_struct =' tmpdt ';']);
    tmpdt = ['head'  num2str(m_channel_sel2(ii))];
    eval(['dt_head =' tmpdt ';']);
    dt = dt_struct.adc;
    alldt = double(dt)*dt_head.adc.Scale+dt_head.adc.DC;
    m_FP.m_Path = m_Path;
    m_FP.FileName = filename;
    m_FP.dataType = 'HEKA';
    m_FP.alldt{index} = alldt;
    totaltime =  (dt_struct.tim(1,2) - dt_struct.tim(1,1))*dt_head.tim.Scale;
    m_FP.sel(index, :)  = [size(alldt,2) 1  ii   totaltime  m_channel_sel2(ii)]; 
    index = index+1;
    
    m_FP.lowestCurr=-200;m_FP.curr_index_0 = 11;  % tem for temprory data.
end

if ~( strcmp(savePath(end),'/') || strcmp(savePath(end),'\') )
    savePath = strcat(savePath,'/');
end
FileName = fullfile( savePath, strcat(filename(1:end-4), '.mat') );
save(FileName,'m_FP');
