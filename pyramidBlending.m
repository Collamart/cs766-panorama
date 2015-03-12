%% Pyramid blending technique
% Reference: http://persci.mit.edu/pub_pdfs/spline83.pdf
%  input:   overlapPixels - the width of the overlap region
%           left - overlap region taken from the left image
%           right - overlap region taken from the right image
%  output:  newOverlap - the blended overlap region
function [newOverlap] = pyramidBlending(overlapPixels, left, right)
N = floor(log2(overlapPixels - 1));

% initialize matrices for gaussian pyramid
GA = zeros([size(left) N+1]);
GB = zeros([size(right) N+1]);
GA(:,:,:,1) = left(:,:,:);
GB(:,:,:,1) = right(:,:,:);

% build gaussian pyramid
gKernel = fspecial('gaussian',5);
for i = 2:N+1
    GA(:,:,:,i) = imfilter(GA(:,:,:,i-1),gKernel,'conv');
    GB(:,:,:,i) = imfilter(GB(:,:,:,i-1),gKernel,'conv');
end

% build laplacian pyramid from difference of gaussians
LA = zeros([size(left) N+1]);
LB = zeros([size(right) N+1]);
for i = 1:N
    LA(:,:,:,i) = GA(:,:,:,i) - GA(:,:,:,i+1);
    LB(:,:,:,i) = GB(:,:,:,i) - GB(:,:,:,i+1);
end
LA(:,:,:,N+1) = GA(:,:,:,N+1);
LB(:,:,:,N+1) = GB(:,:,:,N+1);

% build each side of the overlap region by summing the laplacians
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

newOverlap = zeros(size(left));
for i = 1: N+1
    newOverlap(:,:,:) = newOverlap(:,:,:) + LS(:,:,:,i);
end

end