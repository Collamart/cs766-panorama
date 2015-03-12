%% merge images using Pyramid blending
% reference: http://persci.mit.edu/pub_pdfs/spline83.pdf

function [ finalImg ] = mergePyramid( imgs, transforms, newHeight )
% image information
% height = size(imgs, 1);
% width = size(imgs, 2);
% nChannels = size(imgs, 3);
nImgs = size(imgs, 4);

% blend and build new image
[newImg, extent1] = transformImage(imgs(:,:,:,1), transforms(:,:,1), newHeight);
for i = 2:nImgs
    [img2, extent2] = transformImage(imgs(:,:,:,i), transforms(:,:,i), newHeight);
    
    if (extent1.midXR > extent2.midXL) && (extent1.midXR < extent2.midXR) % left is img 1
        left = newImg;
        right = img2;
        overlap = extent1.maxX - extent2.minX;
    elseif (extent1.midXL > extent2.midXL) && (extent1.midXL < extent2.midXR) % left is img 2
        left = img2;
        right = newImg;
        overlap = extent2.maxX - extent1.minX;
    else
        disp('Error! Consecutive images do not overlap')
        exit(1)
    end

    % build left & right, non-overlapping and overlapping regions
    wL = size(left, 2);
    wR = size(right, 2);
    rightNonOverlap = right(: , (overlap+1):wR, :);
    leftNonOverlap = left(: , 1:(wL-overlap), :);
    rightOverlap = right(: , 1:overlap, :);
    leftOverlap = left(: , (wL-overlap+1):wL, :);

    % new image with blending
    blendedOverlap = pyramidBlending(overlap, leftOverlap, rightOverlap);
    newImg = [leftNonOverlap blendedOverlap rightNonOverlap];
    extent1 = extent2;
end

finalImg = uint8(newImg);
end