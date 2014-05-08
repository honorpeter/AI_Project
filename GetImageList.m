%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% File: GetImageList.m
% Date: 3/30/2014
%
% Author: Jared Bold
%
% Description:
%	Returns a list of the image files within the specified directory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [images] = GetImageList( imgDir )

if ~exist(imgDir, 'dir')
	error( imgDir + 'does not exist!' );
end

images = dir( fullfile(imgDir, '*.p*g' ) ); 