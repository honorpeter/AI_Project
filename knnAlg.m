function [input, results, tTest, tTrain] = knnAlg( dataSet )
%KNNALG Summary of this function goes here
%   Detailed explanation goes here
%     for i = 1:(size(dataSet, 2) - 1)
%         [dataSet(:,i), M, s] = normalize( dataSet(:,i) );
%     end
    tTrain = 0;
    queryImageIndex = find(dataSet(:,end)==1);
    queryImageIndex = queryImageIndex(1);
    imageFeatureKDTree = KDTreeSearcher(dataSet(:,1:end-1));
    [matches, distance] = knnsearch(imageFeatureKDTree,dataSet(queryImageIndex,1:end-1),'K',size(dataSet,1));
    
    tic;
    for i = 1:length(distance)
        if i == length(distance)
%             goodRatioMatches(i) = distance(:,i) < distance(:,i-1) * .8;
            goodDistanceMatches(i) = distance(:,i) < 9.5;
        else
%             goodRatioMatches(i) = distance(:,i) < distance(:,i+1) * .8; % Ratio Test [1]
            goodDistanceMatches(i) = distance(:,i) < 9.5;             % Distance threshold [2
        end
        
    end

    goodMatches = matches .* goodDistanceMatches;
    tTest = toc;
    
    input = dataSet(:,1:end);
    results = -1*ones(length(distance),1);
    for i = 1:length(goodMatches)
        if goodMatches(i) ~= 0
            results(goodMatches(i)) = 1;
        end
    end

end

