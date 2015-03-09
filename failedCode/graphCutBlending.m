%% Graph cut image blending
% based on: "Graphcut Textures: Image and Video Synthesis Using Graph Cuts" (http://www.cc.gatech.edu/cpl/projects/graphcuttextures/)

% right or left means what side the dynamic image is on, either 'left' or
% 'right'

%%% NOT FINISHED YET!!!!

function [blendedImage] = graphCutBlending(overlapPixels, staticImage, dynamicImage, transformMatrix, rightOrLeft)

hS = size(staticImage, 1);
wS = size(staticImage, 2);
channelsS = size(staticImage, 3);

% create new dynamic image with some pixel overlap
newDynamicImage = transformAndCrop(dynamicImage, transformMatrix, rightOrLeft, hS, wS, overlapPixels);
hD = size(newDynamicImage, 1);
wD = size(newDynamicImage, 2);

% figure
% imshow(newDynamicImage)
% figure
% imshow(staticImage)

if strcmpi(rightOrLeft, 'left')
    staticNonOverlap = staticImage(: , (overlapPixels+1):wS, :);
    dynamicNonOverlap = newDynamicImage(: , 1:(wD-overlapPixels), :);
    staticOverlap = staticImage(: , 1:overlapPixels, :);
    dynamicOverlap = newDynamicImage(: , (wD-overlapPixels+1):wD, :);
else
    staticNonOverlap = staticImage(: , 1:(wS-overlapPixels), :);
    dynamicNonOverlap = newDynamicImage(: , (overlapPixels+1):wD, :);
    staticOverlap = staticImage(: , (wS-overlapPixels+1):wS, :);
    dynamicOverlap = newDynamicImage(: , 1:overlapPixels, :);
end

% figure
% imshow(staticNonOverlap)
% figure
% imshow(dynamicNonOverlap)
% figure
% imshow(staticOverlap)
% figure
% imshow(dynamicOverlap)

% compute graph costs
weights = weightMatrix(staticOverlap, dynamicOverlap);

minCut = MinCut([1:size(staticOverlap,2):(size(staticOverlap,2)*size(staticOverlap,1))], weights);
% compute min cut


% reassemble
[r,c,~] = size(staticOverlap);

newOverlap = zeros(r,c,3);
    
currentR = 1;
currentC = 1;
for i = 1:length(weights)
    if currentC == c+1
        currentR = currentR + 1;
        currentC = 1;
    end

    if(isempty(find(minCut(2,:) == i))) %not in source
        newOverlap(currentR, currentC, :) = dynamicOverlap(currentR, currentC, :);
    else
        newOverlap(currentR, currentC, :) = staticOverlap(currentR, currentC, :);
    end

    currentC = currentC + 1;
end

if strcmpi(rightOrLeft, 'left')
    blendedImage = [dynamicNonOverlap uint8(newOverlap) staticNonOverlap];
else
    blendedImage = [staticNonOverlap uint8(newOverlap) dynamicNonOverlap];
end

end

%% basic cost function, s & t are adjacent pixels defined by a vector [y x] (x is on width axis)
function [cost] = basicCostFunction(s,t,S,D)
    cost = norm( S( s(1), s(2) ) - D( s(1), s(2) ) ) + norm( S( t(1), t(2) ) - D( t(1), t(2) ) );
end

%% refined cost function
function [cost] = adaptedCostFunction(s,t,S,D,gS,gD)
    cost = basicCostFunction(s,t,S,D) ./ ...
        ( norm( gS(s(1), s(2)) ) +  norm( gS(t(1), t(2)) ) ... 
        + norm( gD(s(1), s(2)) ) + norm( gD(t(1), t(2)) ) );
end

function [w] = weightMatrix(sOverlap, dOverlap)
    sOverlap = rgb2gray(sOverlap);
    dOverlap = rgb2gray(dOverlap);
    sOverlap = double(sOverlap);
    dOverlap = double(dOverlap);

    %gradients
    [GxS,GyS] = imgradientxy(sOverlap);
    [GxD,GyD] = imgradientxy(dOverlap);
    
    r = size(sOverlap,1);
    c = size(sOverlap,2);
    w = zeros((r*c), (r*c));
    
    currentR = 1;
    currentC = 1;
    for i = 1:length(w)
        if currentC == c+1
            currentR = currentR + 1;
            currentC = 1;
        end
        
        currentPoint = [currentR, currentC];
        
        % down a row
        if (currentR - 1) > 0
            adjPoint = [currentR-1, currentC];
            w(i,i-c) = adaptedCostFunction(currentPoint,adjPoint,sOverlap,dOverlap,GyS,GyD);
%             w(i-c,i) = w(i,i-c);
        end
        
        % up a row
        if (currentR + 1) <= r
            adjPoint = [currentR+1, currentC];
            w(i,i+c) = adaptedCostFunction(currentPoint,adjPoint,sOverlap,dOverlap,GyS,GyD);
%             w(i+c,i) = w(i,i+c);
        end
        
        % down a col
        if (currentC - 1) > 0
            adjPoint = [currentR, currentC-1];
            w(i,i-1) = adaptedCostFunction(currentPoint,adjPoint,sOverlap,dOverlap,GxS,GxD);
%             w(i-1,i) = w(i,i-1);
        end
        
        % up a col
        if (currentC + 1) <= c
            adjPoint = [currentR, currentC+1];
            w(i,i+1) = adaptedCostFunction(currentPoint,adjPoint,sOverlap,dOverlap,GxS,GxD);
%             w(i+1,i) = w(i,i+1);
        end
        
        currentC = currentC + 1;
    end
end





