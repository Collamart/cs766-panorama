%% A test script to evaluate functions to create panoramas using the homography method

addpath(genpath('../')) % added to work with new directory structure

%% setup vlfeat
run(['../lib/vlfeat-0.9.20/toolbox/vl_setup']);

%% non-loop test & no exposure matching & alpha blending
imgFiles = {'TestImages/Test1-1.png', 'TestImages/Test1-2.png'};
imgs = loadImages(imgFiles);
newImg = createPanoramaPla(imgs, false, 'Alpha');
figure;
imshow(newImg);
title('alpha blending')

%% non-loop test & no exposure matching & pyramid blending
imgFiles = {'TestImages/Test1-1.png', 'TestImages/Test1-2.png'};
imgs = loadImages(imgFiles);
newImg = createPanoramaPla(imgs, false, 'Pyramid');
figure;
imshow(newImg);
title('pyramid blending')

%% Bascom test with Alpha blending
imgFiles = {'TestImages/BascomTest2-1.jpg', 'TestImages/BascomTest2-2.jpg',...
    'TestImages/BascomTest2-3.jpg', 'TestImages/BascomTest2-4.jpg',...
    'TestImages/BascomTest2-5.jpg'};
imgs = loadImages(imgFiles);
newImg = createPanoramaPla(imgs, false, 'Alpha');
figure;
imshow(newImg);
title('alpha blending')

%% Bascom test with Pyramid blending
imgFiles = {'TestImages/BascomTest2-1.jpg', 'TestImages/BascomTest2-2.jpg',...
    'TestImages/BascomTest2-3.jpg', 'TestImages/BascomTest2-4.jpg',...
    'TestImages/BascomTest2-5.jpg'};
imgs = loadImages(imgFiles);
newImg = createPanoramaPla(imgs, false, 'Pyramid');
figure;
imshow(newImg);
title('pyramid blending')

rmpath(genpath('../')) % added to work with new directory structure