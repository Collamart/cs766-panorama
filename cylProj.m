function [ cylImg ] = cylProj( img, f, k1, k2 )

height = size(img, 1);
width = size(img, 2);
channel = size(img, 3);

yc = (1 + height) / 2;
xc = (1 + width) / 2;

cylImg = zeros([height width channel], 'like', img);
for yt = 1 : height
    for xt = 1 : width
        theta = (xt - xc) / f;
        h = (yt - yc) / f;
        xCap = sin(theta);
        yCap = h;
        zCap = cos(theta);
        rCapSqr = xCap ^ 2 + yCap ^ 2;
        xCapPrime = xCap / (1 + k1 * rCapSqr + k2 * rCapSqr ^ 2);
        yCapPrime = yCap / (1 + k1 * rCapSqr + k2 * rCapSqr ^ 2);
        x = f * xCapPrime / zCap + xc;
        y = f * yCapPrime / zCap + yc;
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

