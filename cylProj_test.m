img = imread('TestImages/Test2-1.jpg');
f = 595;
cylImg = cylProj(img, f);
imshow(cylImg);