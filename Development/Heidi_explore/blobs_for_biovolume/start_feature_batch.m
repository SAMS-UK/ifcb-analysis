function [ ] = start_feature_batch(in_dir_base , in_dir_blob_base, out_dir_fea_base, parallel_proc_flag)
%function [ ] = start_feature_batch(in_dir_base , in_dir_blob_base, out_dir_fea_base, parallel_proc_flag)
%For example:
%start_feature_batch_user_training('C:\work\IFCB\user_training_test_data\data\2014\' , 'C:\work\IFCB\user_training_test_data\blobs\2014\', 'C:\work\IFCB\user_training_test_data\features\2014\', false)
%
%IFCB image processing: configure and initiate batch processing for feature extraction
%Heidi M. Sosik, Woods Hole Oceanographic Institution, August 2015
%
%example input variables:
%   in_dir_base = 'C:\work\IFCB\user_training_test_data\data\2014\'; %USER where to access roi data
%   in_dir_blob_base = 'C:\work\IFCB\user_training_test_data\blobs\2014\'; %USER where to access blobs
%   out_dir = 'C:\work\IFCB\user_training_test_data\features\2014\'; %USER where to output features
%   parallel_proc_flag = false; %USER true for parallel processing

if ~exist('parallel_proc_flag', 'var')
    parallel_proc_flag = false; % 
end

if ~exist(out_dir_fea_base, 'dir'),
    mkdir(out_dir_fea_base)
end;

daydir = dir([in_dir_base 'D*']);
%daydir = dir([in_dir_base 'D201907*']);

%daydir = dir([in_dir_base 'I*']);
daydir = daydir([daydir.isdir]); 
bins = [];
in_dir = [];
in_dir_blob = [];
out_dir = [];
for ii = 1:length(daydir)
    in_dir_temp = [in_dir_base daydir(ii).name filesep];
    %bins_temp = dir([in_dir_temp '*.adc']);
    %bins_temp = regexprep({bins_temp.name}', '.adc', '');
    in_dir_temp2 = [in_dir_blob_base daydir(ii).name filesep];
    bins_temp = dir([in_dir_temp2 '*.zip']);
    bins_temp = regexprep({bins_temp.name}', '_blobs_v4.zip', '');
    if ~isempty(bins_temp)
    daystr = char(bins_temp(1)); daystr = daystr(1:9);
    out_dir_fea_temp = [out_dir_fea_base daystr filesep];
    bins_done = dir([out_dir_fea_temp '*.csv']);
    bins_done = regexprep({bins_done.name}', '_fea_v4.csv', '');
    [bins_temp,ia] = setdiff(bins_temp, bins_done);
    % daystr = char(bins_temp); daystr = daystr(:,1:14);
     if ~isempty(bins_temp)
        out_dir = [out_dir; cellstr(repmat(out_dir_fea_temp, length(bins_temp),1))];
        in_dir_blob_temp = cellstr(repmat([in_dir_blob_base daystr filesep],length(bins_temp),1));
        bins = [bins; bins_temp];
        in_dir = [in_dir; repmat(cellstr(in_dir_temp),length(bins_temp),1)];
        in_dir_blob = [in_dir_blob; in_dir_blob_temp]; 
     end
    end
end
%bins_done = dir([out_dir '*.csv']);
%bins_done = regexprep({bins_done.name}', '_fea_v4.csv', '');
%[bins,ia] = setdiff(bins, bins_done);
%in_dir = in_dir(ia);
%in_dir_blob = in_dir_blob(ia);

nfiles = length(bins); 
disp(['processing ' num2str(nfiles) ' files'])
if nfiles > 0
    batch_features( in_dir, bins, out_dir, in_dir_blob , parallel_proc_flag);
end

end