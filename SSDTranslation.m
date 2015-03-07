%% function to compute sum of squared errors for translation
function [SSD] = SSDTranslation(datapoint, translation)
    p_prime = translation * datapoint(1,:,2)';
    p = datapoint(1,:,1)';
    difference = p - p_prime;
    sqauredDiff = difference .^ 2;
    SSD = sum(sqauredDiff);
end