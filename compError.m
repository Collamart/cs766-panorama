%% function to compute sum of squared errors
function [SSR] = compError(datapoint, transform)
    p_prime = transform * datapoint(1,:,2)';
    p_prime = (p_prime ./ p_prime(3)); % convert to non-homogeneous coords
    p = datapoint(1,:,1)';
    error = p - p_prime;
    sqauredError = error .^ 2;
    SSR = sum(sqauredError);
end