img = imread('TestImages/Test2-1.jpg');
f = 595;
k1 = -0.15;
k2 = 0;
cylImg = cylProj(img, f, k1, k2);
imshow(cylImg);