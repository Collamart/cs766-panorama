%% load images
img1 = imread('TestImages/Test1-1.png');
img2 = imread('TestImages/Test1-2.png');

%% find feature pairs
pairs = obtainFeaturePairs(img1, img2);