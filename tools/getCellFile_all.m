function [m_CellFile, runnum,  hnum] = getCellFile_all(filename)
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

if isempty(Cindex)  ||  isempty(Rindex)
    m_CellFile = getCellFile(filename);
    runnum = 1;
    return;
end
    
m_CellFile = filename(1:Cindex(1)-1);
if strfind(filename, '.dat')
     runnum =  filename(Rindex(1):end-4);
else
    runnum =  filename(Rindex(1):end);
end