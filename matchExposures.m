function [ newImg2, fit ] = matchExposures( img1, img2, transform )
% parameters
sampleRatio = 0.01;
outlierThreshold = 1.0;

% image information
width = size(img1, 2);
height = size(img1, 1);

% coverting to La*b*
labImg1 = rgb2lab(img1);
labImg2 = rgb2lab(img2);

% sampling correspondences
nPxs = numel(img1);
nSmps = round(nPxs * sampleRatio);
smps = zeros(nSmps, 2);
k = 1;
while true
    p2 = [randi([1 height]); randi([1 width]); 1];
    p1 = transform * p2;
    p1 = p1 ./ p1(3);
    if p1(1) >= 1 && p1(1) < height && p1(2) >= 1 && p1(2) < width
        i = floor(p1(2));
        a = p1(2) - i;
        j = floor(p1(1));
        b = p1(1) - j;
        smp1 = (1 - a) * (1 - b) * labImg1(j, i, 1)...
            + a * (1 - b) * labImg1(j, i + 1, 1)...
            + a * b * labImg1(j + 1, i + 1, 1)...
            + (1 - a) * b * labImg1(j + 1, i, 1);
        smp2 = labImg2(p2(1), p2(2), 1);
        if smp1 > outlierThreshold && smp2 > outlierThreshold
            smps(k, 1) = smp1 / 100;
            smps(k, 2) = smp2 / 100;
            k = k + 1;
            if k > nSmps
                break;
            end
        end
    end
end

% fitting correction curve
fit = fitCurve(smps(:, 2), smps(:, 1));

% matching exposures
labImg2(:, :, 1) = applyCurve(labImg2(:, :, 1) / 100, fit) * 100;
newImg2 = lab2rgb(labImg2, 'OutputType', 'uint8');

% visualizing results
% figure;
% scatter(smps(:, 2), smps(:, 1));
% hold on;
% xplot = 0:0.01:1;
% yplot = applyCurve(xplot, fit);
% plot(xplot, yplot);
% figure;
% imshowpair(img2, newImg2, 'montage');

end

%% fit curve y = y = x .^ gamma
function [ fit ] = fitCurve(x, y)
% parameters
nIters = 1000;
alpha = 1;
% gradient descent
m = length(x);
fit = 1;
for i = 1 : nIters
    fit = fit - alpha * sum((x .^ fit - y) .* log(x) .* (x .^ fit)) / m;
end
end

%% apply curve y = x .^ gamma
function [ y ] = applyCurve(x, fit)
y = x .^ fit;
end
