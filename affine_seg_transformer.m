% Transforming all corresponding segmentation files according to aladin
% output transformation matrix

addpath("~/SLANTbrainSeg-updated/matlab")

t1Path = '/home/neuromedia/Desktop/SLANT_train/t1/';
t1regPath = '/home/neuromedia/Desktop/SLANT_train/mni/t1/';
refSegPath = '/home/neuromedia/Desktop/SLANT_train/lbl/';
destPath = '/home/neuromedia/Desktop/SLANT_train/mni/seg/';

list = dir(t1regPath);

list(1) = []; list(1) = [];

for i=1:length(list)

    cmd_aaa = apply_aladin_affine_via_ants(...
        '/home/neuromedia/SLANT_data/extra/full-multi-atlas/niftyreg/bin',...   % NR_bin
        '/home/neuromedia/SLANT_data/extra/full-multi-atlas/ANTs-bin/bin',...   % ANT_bin
        fullfile(destPath, strcat(list(i).name, ".nii")), ...                   % out_fname
        fullfile(t1Path,  strcat(list(i).name, '.nii')), ...             % in_raw_fname
        fullfile(refSegPath, strcat(list(i).name, "_L.nii")), ...               % in_seg_fname
        fullfile(t1regPath, list(i).name, "target_processed.nii.gz"),...        % target_fname
        fullfile(destPath, list(i).name), ...                                   % out_dir
        fullfile(destPath, strcat(list(i).name,'_tmp')));                       % tmp_dir
    
    run_cmd_single(cmd_aaa);

end