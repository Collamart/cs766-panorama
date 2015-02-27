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
A = zeros(8, 8);
b = zeros(8, 1);
for i = 1:size(cp1,1)
    A(2*i-1,1) = cp2(i,1);
    A(2*i-1,2) = cp2(i,2);
    A(2*i-1,3) = 1;
    A(2*i-1,7) = -cp1(i,1)*cp2(i,1);
    A(2*i-1,8) = -cp1(i,1)*cp2(i,2);
    b(2*i-1) = cp1(i,1);
    A(2*i,4) = cp2(i,1);
    A(2*i,5) = cp2(i,2);
    A(2*i,6) = 1;
    A(2*i,7) = -cp1(i,2)*cp2(i,1);
    A(2*i,8) = -cp1(i,2)*cp2(i,2);
    b(2*i) = cp1(i,2);
end
h = A \ b;
H = [h(1) h(2) h(3); h(4) h(5) h(6); h(7) h(8) 1];

%% merge into panorama -- nearest neighbor
img = [img1 zeros(size(img1))];
h = size(img1, 1);
w = size(img1, 2);
for y = 1 : h
    for x = w+1 : 2*w
        p1 = [y; x; 1];
        p2 = H \ p1;
        p2 = p2 ./ p2(3);
        if p2(1) >= 1 && p2(1) <= h && p2(2) >= 1 && p2(2) <= w
            img(y,x,:) = img2(round(p2(1)),round(p2(2)),:);
        end
    end
end

%% show panorama
figure;
imshow(img);