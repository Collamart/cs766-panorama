%% function returns the feature locations and descriptors. uses VLFeat library

%% input: image -> the image; edgeTresh -> non-edge selection threshold (default should be 10)
function [f, d] = getSIFTFeatures(image, edgeThresh)

%convert images to greyscale
if (size(image, 3) == 3)
    Im = single(rgb2gray(image));
else
    Im = single(image);
end

[f, d] = vl_sift(Im, 'EdgeThresh', edgeThresh);

end