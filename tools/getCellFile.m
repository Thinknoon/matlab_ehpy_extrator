function m_CellFile = getCellFile(filename)

if isempty(filename)
    m_CellFile = filename;
    return;
end

m_Start = 0;
index = 1;
for ii = 1 : length(filename)
    
    tmpnum =  str2num(filename(ii));
    if  (tmpnum >=0) & (tmpnum  <=9) & (m_Start == 0)
        m_Start = 1;
    end
    if isempty(tmpnum) && (m_Start == 1)
        index = ii -1 ;
        break;
    end
end
m_CellFile = filename(1:index+1);