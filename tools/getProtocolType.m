function m_ProtocolType = getProtocolType(m_Tree)
PatchProtocolDefs;

m_ProtocolType = -1;

if isempty(m_Tree)
    m_ProtocolType = -1;
    return;
end

 for iii = 1 : size(m_Tree ,1)
        tmptree = m_Tree{iii, 3};
        if  isempty(tmptree)
            continue;
        end
        if ~isempty(strfind(lower(tmptree.SeLabel),  'cell'))
            m_ProtocolType = PATCH_FP;
            break;
        end
        if ~isempty(strfind(tmptree.SeLabel,  'Sti')) 
            m_ProtocolType = PATCH_STI;
            break;
        end
        if ~isempty(strfind(tmptree.SeLabel,  'FP_axon'))
            m_ProtocolType = Patch_FP_axon;
            break;
        end      
 end
               
            
                

