function m_CellFile = getCellFile_fp(filename)
% get file name and run number
if isempty(filename) 
    m_CellFile = filename;
    return;
end
Cindex = strfind(upper(filename),  'C');
Rindex = strfind(upper(filename),  'R');
Hindex = strfind(upper(filename),  'H');

if ~isempty(Hindex)
    hnum = filename(Hindex(1)+1:end);
else
    hnum = '';
end


    
m_CellFile = filename(1:Cindex(1)-1);
