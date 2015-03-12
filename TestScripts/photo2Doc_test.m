%% A test script to evaluate functions for aligning an  image as a document

addpath(genpath('../')) % added to work with new directory structure

%% setup vlfeat
run(['../lib/vlfeat-0.9.20/toolbox/vl_setup']);

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