%% function returns potential feature matches between two images. uses VLFeat library

%% input: fx -> feature matrix for image x; dx -> descriptor matrix for image x

function [potential_matches, scores] = getPotentialMatches(f1, d1, f2, d2)

[matches, scores] = vl_ubcmatch(d1, d2);

% compute pairs
numMatches = size(matches,2);
pairs = nan(numMatches, 3, 2); % row->each match, col -> <x,y>, dim3 -> <image1,image2>
for mat = 1:numMatches
    f1_index = matches(1,mat);
    f2_index = matches(2,mat);
    
    % x y z=0
    pairs(mat,:,1) = [f1(2,f1_index) f1(1,f1_index) 1]; % img1
    pairs(mat,:,2) = [f2(2,f2_index) f2(1,f2_index) 1]; % img2
end

potential_matches = pairs;

end