imgFiles = {'TestImages/Test2-1.jpg', 'TestImages/Test2-2.jpg',...
    'TestImages/Test2-3.jpg', 'TestImages/Test2-4.jpg',...
    'TestImages/Test2-5.jpg', 'TestImages/Test2-6.jpg',...
    'TestImages/Test2-7.jpg', 'TestImages/Test2-8.jpg',...
    'TestImages/Test2-9.jpg', 'TestImages/Test2-10.jpg',...
    'TestImages/Test2-11.jpg', 'TestImages/Test2-12.jpg',...
    'TestImages/Test2-13.jpg', 'TestImages/Test2-14.jpg',...
    'TestImages/Test2-15.jpg', 'TestImages/Test2-16.jpg',...
    'TestImages/Test2-17.jpg', 'TestImages/Test2-18.jpg'};
% imgFiles = fliplr(imgFiles); % for debugging
imgs = loadImages(imgFiles);
height = size(imgs, 1);
width = size(imgs, 2);
nChannels = size(imgs, 3);
nImgs = size(imgs, 4);

%% cylindrical projection
f = 595;
k1 = 0.15;
k2 = 0;
cylImgs = zeros([height width nChannels nImgs + 1], 'uint8');
for i = 1 : nImgs
    cylImgs(:, :, :, i) = cylProj(imgs(:, :, :, i), f, k1, k2);
end
cylImgs(:, :, :, end) = cylImgs(:, :, :, 1);

%% pairwise alignment
translations = zeros(3, 3, nImgs + 1);
translations(:, :, 1) = eye(3);
[f2, d2] = getSIFTFeatures(cylImgs(:, :, :, 1), 10);
for i = 2 : nImgs + 1
    f1 = f2;
    d1 = d2;
    [f2, d2] = getSIFTFeatures(cylImgs(:, :, :, i), 10);
    [matches, ~] = getPotentialMatches(f1, d1, f2, d2);
    translations(:, :, i) = translations(:, :, i - 1) *...
        RANSAC(0.99, 0.5, 1, matches, 3, @compTranslation, @SSDTranslation);
end

%% drift estimation
driftSlope = translations(1, 3, end) / translations(2, 3, end);
newWidth = abs(round(translations(2, 3, end))) + width;
if translations(2, 3, end) < 0
    translations(2, 3, :) = translations(2, 3, :) - translations(2, 3, end);
    translations(1, 3, :) = translations(1, 3, :) - translations(1, 3, end);
end

%% backward transformation
backTranslations = zeros(size(translations));
for i = 1 : nImgs + 1
    backTranslations(:, :, i) = inv(translations(:, :, i));
end

%% alpha mask
alphaMask = ones(height, width);
alphaMask = cylProj(alphaMask, f, k1, k2);
alphaMask = uint8(1 - alphaMask);
alphaMask = bwdist(alphaMask, 'euclidean');
alphaMask = alphaMask ./ max(max(alphaMask));

%% image merging
newImg = zeros(height, newWidth, nChannels, 'uint8');
for y = 1 : height
    for x = 1 : newWidth
        p1 = [(y + driftSlope * (x - 1)); x; 1];
        pixelSum = zeros(nChannels, 1);
        alphaSum = 0;
        for k = 1 : nImgs + 1
            p2 = backTranslations(:, :, k) * p1;
            if p2(1) >= 1 && p2(1) < height && p2(2) >= 1 && p2(2) < width
                i = floor(p2(2));
                a = p2(2) - i;
                j = floor(p2(1));
                b = p2(1) - j;
                pixel = (1 - a) * (1 - b) * cylImgs(j, i, :, k)...
                    + a * (1 - b) * cylImgs(j, i + 1, :, k)...
                    + a * b * cylImgs(j + 1, i + 1, :, k)...
                    + (1 - a) * b * cylImgs(j + 1, i, :, k);
                alpha = (1 - a) * (1 - b) * alphaMask(j, i)...
                    + a * (1 - b) * alphaMask(j, i + 1)...
                    + a * b * alphaMask(j + 1, i + 1)...
                    + (1 - a) * b * alphaMask(j + 1, i);
                pixelSum = pixelSum + double(squeeze(pixel)) * double(alpha);
                alphaSum = alphaSum + double(alpha);
            end
        end
        newImg(y, x, :) = pixelSum / alphaSum;
    end
end

%% image cropping
croppedImg = newImg(:, width / 2 : newWidth - width / 2, :);

imshow(croppedImg);