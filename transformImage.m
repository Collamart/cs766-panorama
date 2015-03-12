%% Applies a transform to build a section of the final image
%  input:   img - the img to transform
%           transform - the 3x3 transform matrix to apply to the image
%           fullImageHeight - the height (in pixels) of the final image
%  output:  transImg - the image after applying the transform
%           extent - a structure that contains critical coordinate
%           information of this image in the final image reference frame
function [transImg, extent] = transformImage(img, transform, fullImageHeight)
    w = size(img,2);
    h = size(img,1);
    
    % compute critical points (corners) after tranform
    topRight = transform * [1 ; w ; 1];
    topRight = floor(topRight ./ topRight(3));
    
    topLeft = transform * [1 ; 1 ; 1];
    topLeft = floor(topLeft ./ topLeft(3));
    
    bottomRight = transform * [h ; w ; 1];
    bottomRight = floor(bottomRight ./ bottomRight(3));
    
    bottomLeft = transform * [h ; 1 ; 1];
    bottomLeft = floor(bottomLeft ./ bottomLeft(3));
    
    mat = [ topRight, topLeft, bottomRight, bottomLeft ];
    
    % build image extent
    [matMax, indMax] = max(mat,[],2);
    [matMin, indMin] = min(mat,[],2);
    maxY = matMax(1);
    minY = matMin(1);
    maxX = matMax(2);
    minX = matMin(2);
    
    midX = mat(2 , :);
    midX([indMax(2), indMin(2)]) = [];
    midX = sort(midX);

    extent.midXL = midX(1);
    extent.midXR = midX(2);
    extent.maxX = maxX;
    extent.maxY = maxY;
    extent.minY = minY;
    extent.minX = minX;
    extent.topR = mat(1);
    extent.topL = mat(2);
    extent.bottomR = mat(3);
    extent.bottomL = mat(4);
    
    deltaY = maxY - minY;
    deltaX = maxX - minX;
    
    % produce full warped image
    transImg = zeros(fullImageHeight, deltaX, 3);
    for y = 1:fullImageHeight
        for x = minX:maxX
            p1 = [y; x; 1];
            p2 = transform \ p1;
            p2 = p2 ./ p2(3);
            if p2(1) >= 1 && p2(1) < size(img,1) && p2(2) >= 1 && p2(2) < size(img,2)
                i = floor(p2(2));
                a = p2(2) - i;
                j = floor(p2(1));
                b = p2(1) - j;
                transImg(y, x - minX + 1, :) = (1 - a) * (1 - b) * img(j, i, :)...
                    + a * (1 - b) * img(j, i + 1, :)...
                    + a * b * img(j + 1, i + 1, :)...
                    + (1 - a) * b * img(j + 1, i, :);
            end
        end
    end
end