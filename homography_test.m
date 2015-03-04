%% load images
img1 = imread('TestImages/Test1-1.png');
img2 = imread('TestImages/Test1-2.png');

%% show input images
figure;
imshow([img1 img2]);

%% find correspondences -- not so good!
cp1 = [163,343; 234,385; 285,376; 163,298; 285,308];
cp2 = [162,55; 228,98; 277,91; 162,7; 290,25];

%% solve for homography matrix
H = compHomography(cp1, cp2);

%% merge into panorama -- nearest neighbor
img = [img1 zeros(size(img1))];
h = size(img1, 1);
w = size(img1, 2);
ct = 1;
for y = 1 : h
    for x = w+1 : 2*w
        p1 = [y; x; 1];
        p2 = H \ p1;
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