% function to autocrop the image to it's max dimensions... need to clean up
% and document!!!

function [warpedImage] = transformAndCrop(img, transform, leftOrRight, pHeight, pWidth, overlap)
    w = size(img,2);
    h = size(img,1);
    
    % critical points
    topRight = transform * [1 ; w ; 1];
    topRight = floor(topRight ./ topRight(3));
    
    topLeft = transform * [1 ; 1 ; 1];
    topLeft = floor(topLeft ./ topLeft(3));
    
    bottomRight = transform * [h ; w ; 1];
    bottomRight = floor(bottomRight ./ bottomRight(3));
    
    bottomLeft = transform * [h ; 1 ; 1];
    bottomLeft = floor(bottomLeft ./ bottomLeft(3));
    
    mat = [ topRight, topLeft, bottomRight, bottomLeft ];
    
    % compute deltas
    [matMax, indMax] = max(mat,[],2);
    [matMin, indMin] = min(mat,[],2);
    
    % extract middle values
    midY = mat (1 , :);
    midY([indMax(1), indMin(1)]) = [];
    midY = sort(midY);

    midX = mat (2 , :);
    midX([indMax(2), indMin(2)]) = [];
    midX = sort(midX);

    % extract max values
    maxY = matMax(1);
    minY = matMin(1);
    maxX = matMax(2);
    minX = matMin(2);
    
    
    
    if strcmpi(leftOrRight, 'left')
        maxX = overlap;
        minX = midX(1);
    else
        minX = pWidth + 1 - overlap;
        maxX = midX(2);
    end
    
    minY = 1;
    maxY = pHeight;
    
    deltaY = maxY - minY;
    deltaX = maxX - minX;
    
    % produce full warped image
    warpedImage = ones(deltaY, deltaX, 3);
    for y = minY:maxY
        for x = minX:maxX
            p1 = [y; x; 1];
            p2 = transform \ p1;
            p2 = p2 ./ p2(3);
            if p2(1) >= 1 && p2(1) < size(img,1) && p2(2) >= 1 && p2(2) < size(img,2)
                i = floor(p2(2));
                a = p2(2) - i;
                j = floor(p2(1));
                b = p2(1) - j;
                warpedImage(y - minY + 1, x - minX + 1, :) = (1 - a) * (1 - b) * img(j, i, :)...
                    + a * (1 - b) * img(j, i + 1, :)...
                    + a * b * img(j + 1, i + 1, :)...
                    + (1 - a) * b * img(j + 1, i, :);
            end
        end
    end
    
    
%     for y = 1:h-1
%         for x = 1:w-1
%             newCoord = transform * [y ; x ; 1];
%             newCoord = newCoord ./ newCoord(3);
% 
%             i = floor(newCoord(2));
%             a = abs(newCoord(2) - i);
%             
% %             if newCoord(1) < 0
% %                 j = ceil(newCoord(1));
% %             else
% %                 j = floor(newCoord(1));
% %                 
% %             end
%             j = floor(newCoord(1));
%             b = abs(newCoord(1) - j);
%             
%             
%             X = i + abs(minX) + 1;
%             Y = j + abs(minY) + 1;
%             
%             warpedImage(Y, X, :) = (1 - a) * (1 - b) * img(y, x, :)...
%                 + a * (1 - b) * img(y, x + 1, :)...
%                 + a * b * img(y + 1, x + 1, :)...
%                 + (1 - a) * b * img(y + 1, x, :);
%             
% %             warpedImage( Y , X , : ) = img( i , j , :);
%         end
%     end
    warpedImage = uint8(warpedImage);
%     figure
%     imshow(warpedImage)
end