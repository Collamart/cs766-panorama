%% RANSAC test for homography

%% load images
img1 = imread('TestImages/Test1-1.png');
img2 = imread('TestImages/Test1-2.png');

%% get SIFT features
[f1, d1] = getSIFTFeatures(img1, 10);
[f2, d2] = getSIFTFeatures(img2, 10);

%% find feature pairs
[potential_matches, ~] = getPotentialMatches(f1, d1, f2, d2);

%% RANSAC
homography = RANSAC(0.99, 0.3, 4, potential_matches, 3, @compHomography, @SSDHomography);

%% merge into panorama -- nearest neighbor
img = [img1 zeros(size(img1))];
h = size(img1, 1);
w = size(img1, 2);
ct = 1;
for y = 1 : h
    for x = w+1 : 2*w
        p1 = [y; x; 1];
        p2 = homography \ p1;
        p2 = p2 ./ p2(3);
        if p2(1) >= 1 && p2(1) <= h && p2(2) >= 1 && p2(2) <= w
            %img(y, x, :) = img2(round(p2(1)), round(p2(2)), :);
            i = floor(p2(2));
            a = p2(2) - i;
            j = floor(p2(1));
            b = p2(1) - j;
            img(y, x, :) = (1 - a) * (1 - b) * img2(j, i, :)...
                + a * (1 - b) * img2(j, i + 1, :)...
                + a * b * img2(j + 1, i + 1, :)...
                + (1 - a) * b * img2(j + 1, i, :);
        end
    end
end

%% show panorama
figure;
imshow(img);