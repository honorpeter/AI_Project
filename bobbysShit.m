close all 
clear
clc
%% Prepare Collection of Images to Search

% Image Dataset
imageNames = {'riding_a_bike_004.jpg','applauding_001.jpg','blowing_bubbles_001.jpg','brushing_teeth_001.jpg',...
    'cleaning_the_floor_001.jpg','climbing_001.jpg','cooking_001.jpg','cutting_trees_001.jpg',...
    'cutting_vegetables_001.jpg','drinking_001.jpg','feeding_a_horse_001.jpg','fishing_001.jpg',...
    'fixing_a_bike_001.jpg','gardening_001.jpg','holding_an_umbrella_001.jpg','phoning_001.jpg'};

% Initialize structure for images and associated information
numImages = numel(imageNames);
emptyEntry = struct('image',[],'thumbnail',[]);
imageCollection = repmat(emptyEntry,[1 numImages]);
thumbnailSize = 400;
for i = 1:numel(imageCollection)
    imageCollection(i).image = imread(imageNames{i});
    % Convert color images to gray scale
    if size(imageCollection(i).image,3)==3
        imageCollection(i).image = rgb2gray(imageCollection(i).image);
    end
    % Store scaled versions of images for display
    imageCollection(i).thumbnail=imresize(imageCollection(i).image,...
        [thumbnailSize,thumbnailSize]);
end
figure
montage(cat(4,imageCollection.thumbnail));
title('Image Collection');

%% Detect Feature Points in Image Collection

examplePoints=detectSURFFeatures(imageCollection(1).image);
figure; imshow(imageCollection(6).image);
title('100 Strongest Feature Points from first Collection Image');
hold on;
plot(examplePoints.selectStrongest(100));

for l = 1:numel(imageCollection)
    % detect SURF feature points
    imageCollection(l).points = detectSURFFeatures(imageCollection(l).image,...
        'MetricThreshold',600);
    % extract SURF descriptors
    [imageCollection(l).featureVectors,imageCollection(l).validPoints] = ...
        extractFeatures(imageCollection(l).image,imageCollection(l).points);

    % Save the number of features in each image for indexing
    imageCollection(l).featureCount = size(imageCollection(l).featureVectors,1);
end

%% Build Feature Dataset

% Combine all features into dataset
featureDataset = double(vertcat(imageCollection.featureVectors));

% instantiate a kd tree
imageFeatureKDTree = KDTreeSearcher(featureDataset);

%% Choose Refrence Image

rImage.image = imread('riding_a_bike_289.jpg');
rImage.image = rgb2gray(rImage.image);
rImage.thumbnail=imresize(rImage.image,[thumbnailSize,thumbnailSize]);

query.wholeImage = rImage.image;
figure; axesHandle=axes; imshow(query.wholeImage); title('Query Image')
% Note that once the bounding box is displayed, you can move it with your mouse.
% For example, try choosing the staple remover.
rectangleHandle=imrect(axesHandle,[60 150 375 230]); % chooses the bike

%% Detect Feature Points in Query Image

% Consider only selected region
query.image=imcrop(query.wholeImage,getPosition(rectangleHandle));
% Detect SURF features
query.points = detectSURFFeatures(query.image,'MetricThreshold',600);
% Extract SURF descriptors
[query.featureVectors,query.points] = ...
    extractFeatures(query.image,query.points);

% Display feature points
figure; imshow(query.image);
title('100 Strongest Feature Points from Query Image');
hold on;
plot(query.points.selectStrongest(100));

%% Search Image Collection for the Query Image

% Match each query feature to two (K=2) closest features in the dataset.
[matches, distance] = knnsearch(imageFeatureKDTree,query.featureVectors,'K',2);
% Matches contains K indices of the K nearest features in the dataset for each
% feature in the query image. The distance to the second nearest neighbor
% will be used for removing outliers.

indexIntervals = [0, cumsum([imageCollection.featureCount])] + 1;
counts = histc(matches(:, 1), indexIntervals);

% Display count of nearest neighbor features and bins.
figure; bar(indexIntervals,counts,'histc')
title('Number of Nearest Neighbor Features from Each Image')

minImageSize       = 20; % Size for images with no matches
imageScalingFactor = (thumbnailSize - minImageSize)/2;
whiteBackground    = intmax('uint8');

if max(counts)==0
    disp('No Features Matched')
else
    for i = 1:numel(imageCollection) % Scale each image
        newSize = round( counts(i) / max(counts) * imageScalingFactor) * 2 ...
        + minImageSize; % Compute a new size for display
        scaledImage = imresize(imageCollection(i).thumbnail,[newSize,newSize]);
        imageCollection(i).imageHistogramView = padarray(scaledImage,...
            [(thumbnailSize-newSize)/2,(thumbnailSize-newSize)/2],...
            whiteBackground);
    end
end

figure; montage(cat(4,imageCollection.imageHistogramView));
title('Size Corresponds to Number of Nearest Neighbor Occurrences');

%% Eliminate Outliers Using Distance Tests

goodRatioMatches = distance(:,1) < distance(:,2) * .8; % Ratio Test [1]
goodDistanceMatches = distance(:,1) < .25;             % Distance threshold [2]

goodMatches = matches(goodDistanceMatches & goodRatioMatches,1);

% Count number of features that matched from each image using stored
% indices for dataset matrix
counts=histc(goodMatches, indexIntervals);

% Visualize the matches.
minImageSize = 20; % Size for images with no matches
imageScalingFactor = (thumbnailSize - minImageSize)/2;
whiteBackground = 255; % Assumes uint8 images

if max(counts)==0
    disp('No Features Matched')
else
    for i = 1:numel(imageCollection) % Scale each image
        newSize = round( counts(i) / max(counts) * imageScalingFactor) * 2 ...
        + minImageSize; % Compute a new size for display
        scaledImage = imresize(imageCollection(i).thumbnail,[newSize,newSize]);
        imageCollection(i).imageHistogramView = padarray(scaledImage,...
            [(thumbnailSize-newSize)/2,(thumbnailSize-newSize)/2],...
            whiteBackground);
    end
end
figure; montage(cat(4,imageCollection.imageHistogramView));
title('Size Corresponds to Number of Matched Features')
