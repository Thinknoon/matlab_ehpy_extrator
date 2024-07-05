function [sti] = readStimulation(m_FP,dtfile)
%READSTIMULATION 此处显示有关此函数的摘要
%   此处显示详细说明
HEKA_rec = HEKA_Importer(dtfile);
   %%
  try
   if isfield(HEKA_rec.RecTable.stimWave{m_FP.sel(2)}, 'DA_2')
     sti = HEKA_rec.RecTable.stimWave{m_FP.sel(2)}.DA_2;
   else
       if isfield(HEKA_rec.RecTable.stimWave{m_FP.sel(2)}, 'DA_3')
          sti = HEKA_rec.RecTable.stimWave{m_FP.sel(2)}.DA_3;
       else
           if  isfield(HEKA_rec.RecTable.stimWave{m_FP.sel(2)}, 'DA_1')
               sti = HEKA_rec.RecTable.stimWave{m_FP.sel(2)}.DA_1;
           else 
               if  isfield(HEKA_rec.RecTable.stimWave{m_FP.sel(2)}, 'DA_0')
                  sti = HEKA_rec.RecTable.stimWave{m_FP.sel(2)}.DA_0;
               else
                   xx = 0;
               end
           end
       end
   end

  catch
        ss  = 1;
    if isfield(HEKA_rec.RecTable.stimWave{ss}, 'DA_2')
      sti = HEKA_rec.RecTable.stimWave{ss}.DA_2;
   else
       if isfield(HEKA_rec.RecTable.stimWave{ss}, 'DA_3')
          sti = HEKA_rec.RecTable.stimWave{ss}.DA_3;
       else
           if  isfield(HEKA_rec.RecTable.stimWave{ss}, 'DA_1')
               sti = HEKA_rec.RecTable.stimWave{ss}.DA_1;
           else 
               if  isfield(HEKA_rec.RecTable.stimWave{ss}, 'DA_0')
                  sti = HEKA_rec.RecTable.stimWave{ss}.DA_0;
               else
                   xx = 0;
               end
           end
       end
   end

     
 end


