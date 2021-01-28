segDir = '/home/neuromedia/Desktop/SLANT_train/mni/seg/';
saveDir = '/home/neuromedia/Desktop/SLANT_train/mni/refined_seg/';
list=dir(segDir);
list(1) = []; list(1) = [];


numOfLabels = [];
for i=1:length(list)
    mri=niftiread([segDir filesep list(i).name]);
    numOfLabels = [numOfLabels length(unique(mri))];
end

mri=niftiread([segDir filesep list(4).name]);
lbl107 = unique(mri);

lostLbls = {};
for i=1:length(list)
    mri=niftiread([segDir filesep list(i).name]);
    sampLbls = unique(mri);
    lostLbls{i} = [];
    for j=1:length(sampLbls)
        if isempty(find(lbl107==sampLbls(j)))
            lostLbls{i} = [lostLbls{i}, lbl107(j)];
        end
    end
    if ~isempty(lostLbls{i})
        for j=1:length(lostLbls{i})
            mri(mri == lostLbls{i}(j)) = 0;
        end
        niftiwrite(mri, [saveDir list(i).name]);
    end
end
