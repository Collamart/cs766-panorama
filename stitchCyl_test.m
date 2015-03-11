imgFiles = {'TestImages/Test2-1.jpg', 'TestImages/Test2-2.jpg', 'TestImages/Test2-3.jpg'};
% imgFiles = fliplr(imgFiles); % for debugging
imgs = loadImages(imgFiles);
height = size(imgs, 1);
width = size(imgs, 2);
nChannels = size(imgs, 3);
nImgs = size(imgs, 4);

%% cylindrical projection
f = 595;
k1 = -0.15;
k2 = 0;
cylImgs = zeros(size(imgs), 'uint8');
for i = 1 : nImgs
    cylImgs(:, :, :, i) = cylProj(imgs(:, :, :, i), f, k1, k2);
end

%% pairwise alignment
translations = zeros(3, 3, nImgs);
translations(:, :, 1) = eye(3);
[f2, d2] = getSIFTFeatures(cylImgs(:, :, :, 1), 10);
for i = 2 : nImgs
    f1 = f2;
    d1 = d2;
    [f2, d2] = getSIFTFeatures(cylImgs(:, :, :, i), 10);
    [matches, ~] = getPotentialMatches(f1, d1, f2, d2);
    translations(:, :, i) = RANSAC(0.99, 0.5, 1, matches, 3, @compTranslation, @SSDTranslation);
end

%% exposure matching
cylImgs = matchExposures(cylImgs, translations, false);

%% transformation accumulation
accTranslations = zeros(size(translations));
accTranslations(:, :, 1) = translations(:, :, 1);
for i = 2 : nImgs
    accTranslations(:, :, i) = accTranslations(:, :, i - 1) * translations(:, :, i);
end

%% size computation
maxX = width;
minX = 1;
maxY = height;
minY = 1;
frame = [[1; 1; 1], [height; 1; 1], [1; width; 1], [height; width; 1]];
for i = 2 : nImgs 
    newFrame = accTranslations(:, :, i) * frame;
    newFrame(:, 1) = newFrame(:, 1) ./ newFrame(3, 1);
    newFrame(:, 2) = newFrame(:, 2) ./ newFrame(3, 2);
    newFrame(:, 3) = newFrame(:, 3) ./ newFrame(3, 3);
    newFrame(:, 4) = newFrame(:, 4) ./ newFrame(3, 4);
    maxX = max(maxX, max(newFrame(2, :)));
    minX = min(minX, min(newFrame(2, :)));
    maxY = max(maxY, max(newFrame(1, :)));
    minY = min(minY, min(newFrame(1, :)));
end
newWidth = ceil(maxX) - floor(minX) + 1;
newHeight = ceil(maxY) - floor(minY) + 1;
offsetX = 1 - floor(minX);
offsetY = 1 - floor(minY);
accTranslations(2, 3, :) = accTranslations(2, 3, :) + offsetX;
accTranslations(1, 3, :) = accTranslations(1, 3, :) + offsetY;

%% backward transformation
backTranslations = zeros(size(accTranslations));
for i = 1 : nImgs
    backTranslations(:, :, i) = inv(accTranslations(:, :, i));
end

%% alpha mask
alphaMask = ones(height, width);
alphaMask = cylProj(alphaMask, f, k1, k2);
alphaMask = uint8(1 - alphaMask);
alphaMask = bwdist(alphaMask, 'euclidean');
alphaMask = alphaMask ./ max(max(alphaMask));

%% image merging
newImg = zeros(newHeight, newWidth, nChannels, 'uint8');
for y = 1 : newHeight
    for x = 1 : newWidth
        p1 = [y; x; 1];
        pixelSum = zeros(nChannels, 1);
        alphaSum = 0;
        for k = 1 : nImgs
            p2 = backTranslations(:, :, k) * p1;
            % p2 = p2 ./ p2(3);
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

figure;
imshow(newImg);