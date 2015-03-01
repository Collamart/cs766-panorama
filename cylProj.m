function [ cylImg ] = cylProj( img, f )

height = size(img, 1);
width = size(img, 2);
channel = size(img, 3);

yc = (1 + height) / 2;
xc = (1 + width) / 2;
newWidth = floor(atan2(width - xc, f) * f) * 2;
newXc = (1 + newWidth) / 2;

cylImg = zeros([height newWidth channel], 'uint8');
for yt = 1 : height
    for xt = 1 : newWidth
        x = tan((xt - newXc) / f) * f + xc;
        y = sqrt((x - xc) ^ 2 + f ^ 2) * (yt - yc) / f + yc;
        if x >= 1 && x <= width && y >= 1 && y <= height
            % cylImg(yt, xt, :) = img(round(y), round(x), :);
            i = floor(x);
            a = x - i;
            j = floor(y);
            b = y - j;
            cylImg(yt, xt, :) = (1 - a) * (1 - b) * img(j, i, :)...
                + a * (1 - b) * img(j, i + 1, :)...
                + a * b * img(j + 1, i + 1, :)...
                + (1 - a) * b * img(j + 1, i, :);
        end
    end
end

end

