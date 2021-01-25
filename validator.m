addpath("/home/neuromedia/SLANTbrainSeg-updated/matlab");

resultsPath = '/home/neuromedia/SLANT_data/output_test/FinalResult';
refrencePath = '/home/neuromedia/Desktop/OASIS';

resSublist = dir([resultsPath filesep '*.nii.gz']);
refSublist = dir([refrencePath filesep '*_L.nii']);
map = [ 32, 18;     %left-Amygdala
        31, 54;     %Right-Amygdala
        30, 26;     %Left-Accumbens-area
        23, 58;     %Right-Accumbens-area
        4,  14;     %3rd-Ventricle
        11, 15;     %4th-Ventricle
        35, 16;     %Brain-Stem
        36, 50;     %Right-Caudate
        37, 11;     %Left-Caudate
        48, 17;     %Left-Hippocampus
        47, 53;     %Right-Hippocampus
        59, 49;     %Right-Thalamus-proper
        60, 10;     %Left-Thalamus-proper
        56, 13;     %Left-Pallidum
        57, 52;];   %Right-Pallidum

DCs = zeros(length(resSublist), length(map(:,1)));

%for each MR image 
for i = 1:length(resSublist)
    fprintf("preparing image: %d - \n", i)
    resPath = [resSublist(i).folder filesep resSublist(i).name] ;
    refPath = [refSublist(i).folder filesep refSublist(i).name] ;
    
    resMRImg = load_nii_gz(resPath).img;
    refMRImg = niftiread(refPath);
%     refMRImg = imrotate(refMRImg, 180);
%     refMRImg = imrotate3(refMRImg, 180, [0, 0, 1]);
    fprintf("rotating image\n")
    refMRImg = rotator(refMRImg);
%     compareVis(resMRImg, refMRImg,180);
    
    fprintf("computing average dice coeff\n");
    
    for j=1:length(map(:,1))    %for each designated label in SLANT
        sl = map(j,1);
        fl = mapSLANT2FS(sl, map);   %map slant label to corresponding FS lbl
        
        resFlag = flagger(resMRImg, sl);
        refFlag = flagger(refMRImg, fl);
        compareVis(resFlag, refFlag);
        
        comb = single(resFlag) + single(refFlag);

        intersec = length(find(comb==2));

        diceCoeff = ((2*(intersec))/(length(find(resFlag==1))+length(find(refFlag==1))))*100;

%         fprintf("DICE COEFF: %d percent", diceCoeff);
        DCs(i, j) = diceCoeff;
    end
    
    SmplBasedADC = mean(DCs, 2);
    lblBasedADC = mean(DCs, 1);
    
end

function res = mapSLANT2FS(lbl, map)
         
          %SLANT, FS
    index = find(map(:,1)==lbl);
    if isempty(index) 
        res = 0;
    else
        res = map(index, 2);
    end
end

function resFlag = flagger(img, lbl)
    resFlag = img;
    resFlag(resFlag ~= lbl) = 0;
    resFlag(resFlag == lbl) = 1;
end

function compareVis(resImg, refImg, slice)
%     if isempty(slice); slice = 128; end
    if nargin < 3; slice = 128; end
    figure(2);
    subplot(1,2,1);
    imshow(resImg(:,:,slice),[])
    title('SLANT result');

    subplot(1,2,2);
    imshow(refImg(:,:,slice),[])
    title('FreeSurfer result');
end
function res = rotator(img)
    figure(1);
    res = zeros(size(img));
    for i = 1:size(img, 3)
        res(:,:,i) = flipdim(img(:,:,i), 2);
        imshow(res(:,:,i), [])
    end
end