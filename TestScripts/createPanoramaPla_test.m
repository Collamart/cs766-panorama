%% A test script to evaluate functions to create panoramas using the homography method
%% setup vlfeat
run([pwd '/lib/vlfeat-0.9.20/toolbox/vl_setup']);

%% non-loop test & no exposure matching & alpha blending
imgFiles = {'TestImages/Test1-1.png', 'TestImages/Test1-2.png'};
imgs = loadImages(imgFiles);
newImg = createPanoramaPla(imgs, false, 'Alpha');
figure;
imshow(newImg);

%% non-loop test & no exposure matching & pyramid blending
imgFiles = {'TestImages/Test1-1.png', 'TestImages/Test1-2.png'};
imgs = loadImages(imgFiles);
newImg = createPanoramaPla(imgs, false, 'Pyramid');
figure;
imshow(newImg);

%% Bascom test with Alpha blending
imgFiles = {'TestImages/BascomTest2-1.jpg', 'TestImages/BascomTest2-2.jpg',...
    'TestImages/BascomTest2-3.jpg', 'TestImages/BascomTest2-4.jpg',...
    'TestImages/BascomTest2-5.jpg'};
imgs = loadImages(imgFiles);
newImg = createPanoramaPla(imgs, false, 'Alpha');
figure;
imshow(newImg);

%% Bascom test with Pyramid blending
imgFiles = {'TestImages/BascomTest2-1.jpg', 'TestImages/BascomTest2-2.jpg',...
    'TestImages/BascomTest2-3.jpg', 'TestImages/BascomTest2-4.jpg',...
    'TestImages/BascomTest2-5.jpg'};
imgs = loadImages(imgFiles);
newImg = createPanoramaPla(imgs, false, 'Pyramid');
figure;
imshow(newImg);

%% Bascom final
imgFiles = {'TestImages/Bascom2-1.jpg', 'TestImages/Bascom2-2.jpg',...
    'TestImages/Bascom2-3.jpg', 'TestImages/Bascom2-4.jpg',...
    'TestImages/Bascom2-5.jpg'};
imgs = loadImages(imgFiles);
newImg = createPanoramaPla(imgs, false, 'Pyramid');
figure;
imshow(newImg);