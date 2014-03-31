function [ normX, M, s ] = normalize( X )
%NORMALIZE Normalizes an input vector X and returns the normalized vector
% also returns the mean and standard deviation of the vector
    M = mean(X);
    s = std(X);
    if s == 0
        normX = 0;
    else
        normX = (X-M)./s;
    end
end

