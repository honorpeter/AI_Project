%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% File: GetFeatures.m
% Date: 3/30/2014
% Author: Jared Bold
%
% Description:
%   Returns a feature vector
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ftv] = GetFeatures( imgPath )

if ~exist(imgPath, 'file')
    error( '%s Does not exist!', imgPath );
end

img = imread( imgPath );
if ndims(img) == 3
    img = rgb2gray( img );              % Convert the image to grayscale
end
[w, h] = size(img);
mDim= max([w,h]);
img = imresize( img, [128 128] );

surf = detectSURFFeatures(img,'MetricThreshold',600);
[featureVector, featurePoints] = extractFeatures( img, surf);
%hog = vl_hog( single(img), cellSize, 'numOrientations', 8 , 'variant', 'dalaltriggs','bilinearOrientations');

ftv = reshape(featureVector, 1, numel(featureVector));
clear img;
end