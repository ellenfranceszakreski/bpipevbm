% segmentation and tissue volume computation
%% subject's Input directory
matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_named_dir.name = 'subx directory';
matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_named_dir.dirs = {'<UNDEFINED>'};

%% select image
matlabbatch{2}.cfg_basicio.file_dir.file_ops.file_fplist.dir(1) = cfg_dep('Named Directory Selector: subx directory(1)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','dirs', '{}',{1}));
matlabbatch{2}.cfg_basicio.file_dir.file_ops.file_fplist.filter = '^sub\d+_bpipe.nii';
matlabbatch{2}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';

%% segment
matlabbatch{3}.spm.spatial.preproc.channel.vols(1) = cfg_dep('File Selector (Batch Mode): Selected Files (^sub\d+_bpipe.nii)', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{3}.spm.spatial.preproc.channel.biasreg = 0;
matlabbatch{3}.spm.spatial.preproc.channel.biasfwhm = Inf;
matlabbatch{3}.spm.spatial.preproc.channel.write = [1 1]; % save bias field and bias corrected image (so SPM does not look for files)
  
matlabbatch{3}.spm.spatial.preproc.tissue(1).tpm = {[spm('dir'),'/tpm/TPM.nii,1']}; % gray matter
matlabbatch{3}.spm.spatial.preproc.tissue(1).ngaus = 1;
matlabbatch{3}.spm.spatial.preproc.tissue(1).native = [1 1]; % Native and DARTEL
matlabbatch{3}.spm.spatial.preproc.tissue(1).warped = [1 1]; % modulated and unmodulated
  
matlabbatch{3}.spm.spatial.preproc.tissue(2).tpm = {[spm('dir'),'/tpm/TPM.nii,2']}; % white mtter
matlabbatch{3}.spm.spatial.preproc.tissue(2).ngaus = 1;
matlabbatch{3}.spm.spatial.preproc.tissue(2).native = [1 1]; % Native and DARTEL
matlabbatch{3}.spm.spatial.preproc.tissue(2).warped = [1 1]; % modulated and unmodulated
  
matlabbatch{3}.spm.spatial.preproc.tissue(3).tpm = {[spm('dir'),'/tpm/TPM.nii,3']}; % CSF
matlabbatch{3}.spm.spatial.preproc.tissue(3).ngaus = 2;
matlabbatch{3}.spm.spatial.preproc.tissue(3).native = [1 1]; % Native and DARTEL
matlabbatch{3}.spm.spatial.preproc.tissue(3).warped = [1 1]; % modulated and unmodulated
matlabbatch{3}.spm.spatial.preproc.tissue(4).tpm = {[spm('dir'),'/tpm/TPM.nii,4']};

matlabbatch{3}.spm.spatial.preproc.tissue(4).ngaus = 3;
matlabbatch{3}.spm.spatial.preproc.tissue(4).native = [1 0]; % Native
matlabbatch{3}.spm.spatial.preproc.tissue(4).warped = [0 0];

matlabbatch{3}.spm.spatial.preproc.tissue(5).tpm = {[spm('dir'),'/tpm/TPM.nii,5']};
matlabbatch{3}.spm.spatial.preproc.tissue(5).ngaus = 4;
matlabbatch{3}.spm.spatial.preproc.tissue(5).native = [1 0];
matlabbatch{3}.spm.spatial.preproc.tissue(5).warped = [0 0];
matlabbatch{3}.spm.spatial.preproc.tissue(6).tpm = {[spm('dir'),'/tpm/TPM.nii,6']};
matlabbatch{3}.spm.spatial.preproc.tissue(6).ngaus = 2;
matlabbatch{3}.spm.spatial.preproc.tissue(6).native = [0 0];
matlabbatch{3}.spm.spatial.preproc.tissue(6).warped = [0 0];

matlabbatch{3}.spm.spatial.preproc.warp.mrf = 1;
matlabbatch{3}.spm.spatial.preproc.warp.cleanup = 1;
matlabbatch{3}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
matlabbatch{3}.spm.spatial.preproc.warp.affreg = 'mni';
matlabbatch{3}.spm.spatial.preproc.warp.fwhm = 0;
matlabbatch{3}.spm.spatial.preproc.warp.samp = 1; % high quality
matlabbatch{3}.spm.spatial.preproc.warp.write = [1 1];

%% get tissue volumes
matlabbatch{4}.spm.util.tvol.matfiles(1) = cfg_dep('Segment: Seg Params', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','param', '()',{':'}));
matlabbatch{4}.spm.util.tvol.tmax = 3; % use first 3 channels (gray matter, white matter and CSF)
matlabbatch{4}.spm.util.tvol.mask = {[spm('dir'),'/tpm/mask_ICV.nii,1']};
matlabbatch{4}.spm.util.tvol.outf = '';

%% save gray matter, white matter, CSF volumes and intracranial volume (ICV)
matlabbatch{5}.cfg_basicio.var_ops.cfg_save_vars.name = 'icv_vol';
matlabbatch{5}.cfg_basicio.var_ops.cfg_save_vars.outdir(1) = cfg_dep('Named Directory Selector: subx directory(1)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','dirs', '{}',{1}));
matlabbatch{5}.cfg_basicio.var_ops.cfg_save_vars.vars(1).vname = 'c1';
matlabbatch{5}.cfg_basicio.var_ops.cfg_save_vars.vars(1).vcont(1) = cfg_dep('Tissue Volumes: 1', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','vol1'));
matlabbatch{5}.cfg_basicio.var_ops.cfg_save_vars.vars(2).vname = 'c2';
matlabbatch{5}.cfg_basicio.var_ops.cfg_save_vars.vars(2).vcont(1) = cfg_dep('Tissue Volumes: 2', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','vol2'));
matlabbatch{5}.cfg_basicio.var_ops.cfg_save_vars.vars(3).vname = 'c3';
matlabbatch{5}.cfg_basicio.var_ops.cfg_save_vars.vars(3).vcont(1) = cfg_dep('Tissue Volumes: 3', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','vol3'));
matlabbatch{5}.cfg_basicio.var_ops.cfg_save_vars.vars(4).vname = 'icv';
matlabbatch{5}.cfg_basicio.var_ops.cfg_save_vars.vars(4).vcont(1) = cfg_dep('Tissue Volumes: Sum',substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','vol_sum'));
matlabbatch{5}.cfg_basicio.var_ops.cfg_save_vars.saveasstruct = false;
