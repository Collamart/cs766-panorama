% pyramid blending
% reference: http://persci.mit.edu/pub_pdfs/spline83.pdf

function [blendedImage] = pyramidBlending(overlapPixels, staticImage, dynamicImage, transformMatrix, rightOrLeft)
N = floor(log2(overlapPixels - 1));
hS = size(staticImage, 1);
wS = size(staticImage, 2);
channelsS = size(staticImage, 3);

% create new dynamic image with some pixel overlap
newDynamicImage = transformAndCrop(dynamicImage, transformMatrix, rightOrLeft, hS, wS, 25);
% imshow(newDynamicImage);
hD = size(newDynamicImage, 1);
wD = size(newDynamicImage, 2);

if strcmpi(rightOrLeft, 'left')
    staticNonOverlap = staticImage(: , (overlapPixels+1):wS, :);
    dynamicNonOverlap = newDynamicImage(: , 1:(wD-overlapPixels), :);
    staticOverlap = staticImage(: , 1:overlapPixels, :);
    dynamicOverlap = newDynamicImage(: , (wD-overlapPixels+1):wD, :);
    left = dynamicOverlap;
    right = staticOverlap;
else
    staticNonOverlap = staticImage(: , 1:(wS-overlapPixels), :);
    dynamicNonOverlap = newDynamicImage(: , (overlapPixels+1):wD, :);
    staticOverlap = staticImage(: , (wS-overlapPixels+1):wS, :);
    dynamicOverlap = newDynamicImage(: , 1:overlapPixels, :);
    left = staticOverlap;
    right = dynamicOverlap;
end

% imshow(left);
% imshow(right);

GA = zeros([size(left) N+1]);
GB = zeros([size(right) N+1]);
GA(:,:,:,1) = left(:,:,:);
GB(:,:,:,1) = right(:,:,:);

% imshow(uint8(GA(:,:,:,1)));
% imshow(uint8(GB(:,:,:,1)));

% build pyramid
gKernel = fspecial('gaussian',5);
for i = 2:N+1
    GA(:,:,:,i) = imfilter(GA(:,:,:,i-1),gKernel,'conv');
    GB(:,:,:,i) = imfilter(GB(:,:,:,i-1),gKernel,'conv');
    
%     imshow(uint8(GA(:,:,:,i)));
%     imshow(uint8(GB(:,:,:,i)));
end

% laplacians
LA = zeros([size(left) N+1]);
LB = zeros([size(right) N+1]);
for i = 1:N
    LA(:,:,:,i) = GA(:,:,:,i) - GA(:,:,:,i+1);
    LB(:,:,:,i) = GB(:,:,:,i) - GB(:,:,:,i+1);
    
%     imshow(uint8(LA(:,:,:,i)));
%     imshow(uint8(LB(:,:,:,i)));
end
LA(:,:,:,N+1) = GA(:,:,:,N+1);
LB(:,:,:,N+1) = GB(:,:,:,N+1);

LS = zeros(size(LA));
for l = 1:N+1
    for i = 1:size(LA,1)
        for j = 1:size(LA,2)
            if j < (2^N)
                LS(i,j,:,l) = LA(i,j,:,l);
            elseif j == (2^N)
                LS(i,j,:,l) = (LA(i,j,:,l) + LB(i,j,:,l)) ./ 2;
            else
                LS(i,j,:,l) = LB(i,j,:,l);
            end
        end
    end
end

newOverlap = zeros(size(staticOverlap));
for i = 1: N+1
    newOverlap(:,:,:) = newOverlap(:,:,:) + LS(:,:,:,i);
end

if strcmpi(rightOrLeft, 'left')
    blendedImage = [dynamicNonOverlap uint8(newOverlap) staticNonOverlap];
else
    blendedImage = [staticNonOverlap uint8(newOverlap) dynamicNonOverlap];
end

% 
% 
% newLevel = 
% figure;imshow(newLevel);

end

% function [expanded] = expand(G, l, k)
%     for i = size(G,1)
%         for j = size(G,2)
%             expanded(i,j,:,l)
%         end
%     end
% end