function  [alldt,  m_Sti, m_StiTime] = getChanData_all(m_Path, filename,  m_chan)
% m_chan number
clear('chan*');
clear('head*');
clear('FileSource');
m_Sti = [];
alldt = [];
m_StiTime = [];
filename = [m_Path filename  '.mat'];
if exist(filename)
   load(filename);
   m_totalchan = length(who(['chan*']));    
   m_trialnum = floor(m_totalchan/m_chan);
   %% select best stimulis
   m_StiIndex = 1;
   for ii = 1 : m_trialnum
       tmpdt = ['chan'  num2str((ii-1)*m_chan+1)];
       eval(['dt_struct =' tmpdt ';']);
       dt = dt_struct.adc;
       tmpdt = ['head'  num2str((ii-1)*m_chan+1)];
       eval(['dt_head =' tmpdt ';']);  
       if strcmp(dt_head.Group.Label(1:3),  'Sti') ==  1  
         	 m_sel(m_StiIndex) = ii;
             stiindex1 = strfind(dt_head.Group.Label,  'Sti');
             stiindex2 = strfind(dt_head.Group.Label,  'S-');
             selsti = strtrim(dt_head.Group.Label(stiindex1(1)+4:stiindex2(1)-1));
             m_Sti(m_StiIndex,  :)  =  [str2num(selsti)  size(dt, 2)] ;
             m_StiTime(m_StiIndex,  :)  =  (dt_struct.tim(1,2) - dt_struct.tim(1,1))*dt_head.tim.Scale;
             m_StiIndex = m_StiIndex + 1;
       end
   end
   for ii  = 1 : size(m_Sti, 1)
     for jj = 1 : m_chan
       tmpdt = ['chan'  num2str((m_sel(ii)-1)*m_chan+jj)];
       eval(['dt_struct =' tmpdt ';']);
       dt = dt_struct.adc;
       tmpdt = ['head'  num2str((m_sel(ii)-1)*m_chan+jj)];
       eval(['dt_head =' tmpdt ';']); 
       alldt{ii, jj} = double(dt)*dt_head.adc.Scale+dt_head.adc.DC;
     end 
   end
end

