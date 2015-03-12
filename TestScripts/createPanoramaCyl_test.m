%% A test script to evaluate functions to create panoramas using the cylindrical projection method

addpath(genpath('../')) % added to work with new directory structure

%% setup vlfeat
run(['../lib/vlfeat-0.9.20/toolbox/vl_setup']);

%% non-loop test & no exposure matching & no blending
imgFiles = {'TestImages/Test2-1.jpg', 'TestImages/Test2-2.jpg', 'TestImages/Test2-3.jpg'};
imgs = loadImages(imgFiles);
newImg = createPanoramaCyl(imgs, 595, -0.15, 0, false, false, 'NoBlend');
figure;
imshow(newImg);

%% non-loop test & exposure matching & no blending
imgFiles = {'TestImages/Test2-1.jpg', 'TestImages/Test2-2.jpg', 'TestImages/Test2-3.jpg'};
imgs = loadImages(imgFiles);
newImg = createPanoramaCyl(imgs, 595, -0.15, 0, false, true, 'NoBlend');
figure;
imshow(newImg);

%% non-loop test & exposure matching & pyramid blending
imgFiles = {'TestImages/Test2-1.jpg', 'TestImages/Test2-2.jpg', 'TestImages/Test2-3.jpg'};
imgs = loadImages(imgFiles);
newImg = createPanoramaCyl(imgs, 595, -0.15, 0, false, false, 'Pyramid');
figure;
imshow(newImg);

%% non-loop test & exposure matching & alpha blending
imgFiles = {'TestImages/Test2-1.jpg', 'TestImages/Test2-2.jpg', 'TestImages/Test2-3.jpg'};
imgs = loadImages(imgFiles);
newImg = createPanoramaCyl(imgs, 595, -0.15, 0, false, true, 'Alpha');
figure;
imshow(newImg);

%% loop test
imgFiles = {'TestImages/Test2-1.jpg', 'TestImages/Test2-2.jpg',...
    'TestImages/Test2-3.jpg', 'TestImages/Test2-4.jpg',...
    'TestImages/Test2-5.jpg', 'TestImages/Test2-6.jpg',...
    'TestImages/Test2-7.jpg', 'TestImages/Test2-8.jpg',...
    'TestImages/Test2-9.jpg', 'TestImages/Test2-10.jpg',...
    'TestImages/Test2-11.jpg', 'TestImages/Test2-12.jpg',...
    'TestImages/Test2-13.jpg', 'TestImages/Test2-14.jpg',...
    'TestImages/Test2-15.jpg', 'TestImages/Test2-16.jpg',...
    'TestImages/Test2-17.jpg', 'TestImages/Test2-18.jpg'};
imgs = loadImages(imgFiles);
newImg = createPanoramaCyl(imgs, 595, -0.15, 0, true, true, 'Alpha');
figure;
imshow(newImg);

%% loop test with pyramid blending
imgFiles = {'TestImages/Test2-1.jpg', 'TestImages/Test2-2.jpg',...
    'TestImages/Test2-3.jpg', 'TestImages/Test2-4.jpg',...
    'TestImages/Test2-5.jpg', 'TestImages/Test2-6.jpg',...
    'TestImages/Test2-7.jpg', 'TestImages/Test2-8.jpg',...
    'TestImages/Test2-9.jpg', 'TestImages/Test2-10.jpg',...
    'TestImages/Test2-11.jpg', 'TestImages/Test2-12.jpg',...
    'TestImages/Test2-13.jpg', 'TestImages/Test2-14.jpg',...
    'TestImages/Test2-15.jpg', 'TestImages/Test2-16.jpg',...
    'TestImages/Test2-17.jpg', 'TestImages/Test2-18.jpg'};
imgs = loadImages(imgFiles);
newImg = createPanoramaCyl(imgs, 595, -0.15, 0, true, false, 'Pyramid');
figure;
imshow(newImg);

%% Bascom Test
imgFiles = {'TestImages/BascomTest1-1.jpg', 'TestImages/BascomTest1-2.jpg',...
    'TestImages/BascomTest1-3.jpg', 'TestImages/BascomTest1-4.jpg',...
    'TestImages/BascomTest1-5.jpg', 'TestImages/BascomTest1-6.jpg',...
    'TestImages/BascomTest1-7.jpg', 'TestImages/BascomTest1-8.jpg',...
    'TestImages/BascomTest1-9.jpg', 'TestImages/BascomTest1-10.jpg',...
    'TestImages/BascomTest1-11.jpg', 'TestImages/BascomTest1-12.jpg'};
imgs = loadImages(imgFiles);
newImg = createPanoramaCyl(imgs, 575, -0.15, 0, false, false, 'Alpha');
figure;
imshow(newImg);

%% Bascom Test with Pyramid
imgFiles = {'TestImages/BascomTest1-1.jpg', 'TestImages/BascomTest1-2.jpg',...
    'TestImages/BascomTest1-3.jpg', 'TestImages/BascomTest1-4.jpg',...
    'TestImages/BascomTest1-5.jpg', 'TestImages/BascomTest1-6.jpg',...
    'TestImages/BascomTest1-7.jpg', 'TestImages/BascomTest1-8.jpg',...
    'TestImages/BascomTest1-9.jpg', 'TestImages/BascomTest1-10.jpg',...
    'TestImages/BascomTest1-11.jpg', 'TestImages/BascomTest1-12.jpg'};
imgs = loadImages(imgFiles);
newImg = createPanoramaCyl(imgs, 575, -0.15, 0, false, false, 'Pyramid');
figure;
imshow(newImg);

rmpath(genpath('../')) % added to work with new directory structure