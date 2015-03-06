%% function to compute sum of squared errors for homography
function [SSD] = SSDHomography(datapoint, homography)
    p_prime = homography * datapoint(1,:,2)';
    p_prime = (p_prime ./ p_prime(3)); % convert to non-homogeneous coords
    p = datapoint(1,:,1)';
    difference = p - p_prime;
    sqauredDiff = difference .^ 2;
    SSD = sum(sqauredDiff);
end