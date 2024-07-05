function  [alldt,  m_Sti, m_StiTime] = getChanData(m_Path, filename,  m_chan)
% m_chan number
clear('chan*');
clear('head*');
clear('FileSource');
filename = [m_Path filename  '.mat'];
if exist(filename)
   load(filename);
   m_totalchan = length(who(['chan*']));    
   m_trialnum = floor(m_totalchan/m_chan);
   %% select best stimulis
   maxsweep = 0;
   m_sel = 1;
   m_Sti = 0;
   for ii = 1 : m_trialnum
       tmpdt = ['chan'  num2str((ii-1)*m_chan+1)];
       eval(['dt_struct =' tmpdt ';']);
       dt = dt_struct.adc;
       tmpdt = ['head'  num2str((ii-1)*m_chan+1)];
       eval(['dt_head =' tmpdt ';']);  
       if strcmp(dt_head.Group.Label(1:3),  'Sti') ==  1
          if  maxsweep  <  size(dt, 2) 
             maxsweep = size(dt, 2); 
         	 m_sel = ii;
             stiindex = strfind(dt_head.Group.Label,  'S-');
             m_Sti  =  str2num(dt_head.Group.Label(stiindex-1));
             m_StiTime  =  (dt_struct.tim(:,2) - dt_struct.tim(:,1))*dt_head.tim.Scale;
          end
       end
   end
   
   for ii = 1 : m_chan
       tmpdt = ['chan'  num2str((m_sel-1)*m_chan+ii)];
       eval(['dt_struct =' tmpdt ';']);
       dt = dt_struct.adc;
       tmpdt = ['head'  num2str((m_sel-1)*m_chan+ii)];
       eval(['dt_head =' tmpdt ';']); 
       alldt{ii} = double(dt)*dt_head.adc.Scale+dt_head.adc.DC;
   end 
end
