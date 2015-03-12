%% A test script to evaluate the cylindrical projection method

addpath(genpath('../')) % added to work with new directory structure

%% setup vlfeat
run(['../lib/vlfeat-0.9.20/toolbox/vl_setup']);

img = imread('TestImages/Test2-1.jpg');
f = 595;
k1 = -0.15;
k2 = 0;
cylImg = cylProj(img, f, k1, k2);
imshow(cylImg);

rmpath(genpath('../')) % added to work with new directory structure