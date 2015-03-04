%% Get features pairs using SIFT features
% Uses VLFeat to obtain SIFT feature pairs

%% NOT FINISHED!
% 1) Add edge and peak threshold params
% 2) return descriptors and features
function [potential_matches] = obtainFeaturePairs(image1, image2)

% setup VLFeat
currentFolder = pwd;
run([currentFolder '/lib/vlfeat-0.9.20/toolbox/vl_setup'])

%convert images to greyscale
if (size(image1, 3) == 3)
    IM1 = single(rgb2gray(image1));
else
    IM1 = single(image1);
end

if (size(image2, 3) == 3)
    IM2 = single(rgb2gray(image2));
else
    IM2 = single(image2);
end

% Get SIFT features for images
[f1, d1] = vl_sift(IM1);
[f2, d2] = vl_sift(IM2);

% Get matching pairs
[matches, scores] = vl_ubcmatch(d1, d2);

f1_match = f1(:,unique(matches(1,:)));
d1_match = d1(:,unique(matches(1,:)));

f2_match = f2(:,unique(matches(2,:)));
d2_match = d2(:,unique(matches(2,:)));

% plot results
figure;
image(image1);
feat1 = vl_plotframe(f1_match) ;
set(feat1,'color','y') ;
% desc1 = vl_plotsiftdescriptor(d1_match,f1_match);
% set(desc1,'color','g') ;

figure;
image(image2);
feat2 = vl_plotframe(f2_match) ;
set(feat2,'color','y') ;
% desc2 = vl_plotsiftdescriptor(d2_match,f2_match);
% set(desc2,'color','g') ;

% compute pairs
numMatches = size(matches,2);
pairs = nan(numMatches, 2, 2); % row->each match, col -> <x,y>, dim3 -> <image1,image2>
for mat = 1:numMatches
    f1_index = matches(1,mat);
    f2_index = matches(2,mat);
    
    pairs(mat,:,1) = f1(1:2,f1_index)';
    pairs(mat,:,2) = f2(1:2,f2_index)';
end

potential_matches = pairs;
end