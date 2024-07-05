all_matFiles = dir('J:\HuangMY\LIP\ephys\matlab_ephys\*.mat');
workPath = 'I:\Matlab_cell_ephy_extractor\';
for i =1:length(all_matFiles)
    saveName = strcat(workPath,'calculatedData\',all_matFiles(i).name);
    if exist(saveName,'file')
        fprintf(strcat('file ',all_matFiles(i).name ,'already exists, goto next......\n'));
        continue;
    end
    matFilePath = fullfile(all_matFiles(i).folder,all_matFiles(i).name);
    [Attr,~]=createFeatures(matFilePath);
    fprintf('%d of total %d processed',i,length(all_matFiles));
    save(saveName,'Attr')    
end    
