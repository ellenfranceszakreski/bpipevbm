% append this code after defning variable subx
% e.g. subx = 'sub9';
subx = char(subx);
%% set up cluster
number_of_cores=12;
d=tempname();% get temporary directory location
mkdir(d);
% create cluster
cluster = parallel.cluster.Local('JobStorageLocation',d,'NumWorkers',number_of_cores);
matlabpool(cluster, number_of_cores);

%% run analysis
% get data for subject

addpath(genpath(fullfile(spm('dir'),'config')));
AnalysisDir='/data/scratch/zakell/bpipevbm'; % <-make sure this is correct

jobs = {[AnalysisDir,'/Scripts/segment_job.m']};
inputs = {{[AnalysisDir,'/Input/',subx]}}; % Named Directory Selector: Directory - cfg_files (subject dir)

spm('defaults', 'PET'); % defaults same as VBM
spm_jobman('run', jobs, inputs{:});
% done
