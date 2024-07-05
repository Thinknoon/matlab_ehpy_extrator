all_file_name = dir('.\data\*.dat');
savePath = '.\dat2matFiles\';
readHEKA_file( all_file_name(1).name,all_file_name(1).folder,8,savePath );