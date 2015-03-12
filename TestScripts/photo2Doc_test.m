addpath(genpath('../')) % added to work with new directory structure

%% test case 1
img = imread('TestImages/TestEx1-1.jpg');
newImg = photo2Doc(img);
figure;
imshowpair(img, newImg, 'montage');

%% test case 2
img = imread('TestImages/TestEx1-2.jpg');
newImg = photo2Doc(img);
figure;
imshowpair(img, newImg, 'montage');

%% test case 3
img = imread('TestImages/TestEx1-3.jpg');
newImg = photo2Doc(img);
figure;
imshowpair(img, newImg, 'montage');

rmpath(genpath('../')) % added to work with new directory structure