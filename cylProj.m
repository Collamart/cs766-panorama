function [ cylImg ] = cylProj( img, f, k1, k2 )

height = size(img, 1);
width = size(img, 2);
channel = size(img, 3);

yc = (1 + height) / 2;
xc = (1 + width) / 2;

cylImg = zeros([height width channel], 'like', img);
for yt = 1 : height
    for xt = 1 : width
        % radial distortion correction
        xd = (xt - xc) / f;
        yd = (yt - yc) / f;
        rSqr = xd * xd + yd * yd;
        coeff = 1 + k1 * rSqr + k2 * rSqr * rSqr;
        xn = xd * coeff;
        yn = yd * coeff;
        % cylindrical warping
        theta = xn;
        h = yn;
        xCap = sin(theta);
        yCap = h;
        zCap = cos(theta);
        x = f * xCap / zCap + xc;
        y = f * yCap / zCap + yc;
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

