%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% File: Project.m
% Date:	3/30/2014
%
% Authors: Jared Bold, Daniel Jang, Bobby Jones
%
% Description:
%	MATLAB script to implement the AI Explorations final project.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
clc;
% Read in the list of all images files that we have at our disposal
dataFile = 'dataAll.csv';
tReadFile = 0;
tWriteFile = 0;
tGenData = 0;
if exist( dataFile, 'file' )
    data = csvread(dataFile);    
else
    imageDir = './Images';
    Images = GetImageList( imageDir );
    
    % We are only training on one situation, so lets decide what that is
    cat = 'reading';
    class = zeros( size(Images) );
    for i = 1:size(Images, 1)
        if ~isempty( strfind( Images(i).name, cat ) )
            class(i,1) = 1;
        else
            class(i,1) = 0;
        end
    end
    % Now we have to get the image features of each image
    featVector = GetFeatures( strcat(imageDir, '/', Images(1).name) );
    for i = 2:size(Images, 1)
        imgpath = strcat(imageDir, '/', Images(i).name);
        fts = GetFeatures(imgpath);
        if size(fts,2) < size(featVector,2)
            fts = padarray(fts, [0, size(featVector,2)-size(fts,2)],0,'post');
        elseif size(fts,2) > size(featVector,2)
            featVector = padarray(featVector, [0, size(fts,2)-size(featVector,2)],0,'post');
        end
        featVector = [featVector; fts];
    end
    data = [featVector, class];
    clear featVector;
    csvwrite( dataFile, data );
end

%% Separate into training and test data
for i = 1:(size(data,2) - 1)
    [data(:,i), a, b] = normalize(data(:,i));
end
[trainSet, testSet] = divideset( data, 0.5, 0.5 );

while 1
    fprintf( '1) Baseline\n' );
    fprintf( '2) Quit\n' );
    fprintf( '\n' );
    sel = input( 'Select algorithm: ' );
    switch sel
        case 1
            [testRes, tTrain, tTest] = baselineAlg( trainSet, testSet );
            baseConfMat = confusionmat( testSet(:,end), testRes);
            disp( baseConfMat );
            fprintf( 'Correct: %3.3f\n', 100*(baseConfMat(1,1)+baseConfMat(2,2))/sum(sum(baseConfMat)));
            fprintf( 'Wrong: %3.3f\n\n', 100*(baseConfMat(1,2)+baseConfMat(2,1))/sum(sum(baseConfMat)));
        case 2
            break;
    end
end

		
