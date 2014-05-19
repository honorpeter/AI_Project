function [input, results, tTest, tTrain] = baselineAlg( dataSet )
    
    [crossSet1, crossSet2] = divideset( dataSet, 1/3, 2/3 );
    [crossSet2, crossSet3] = divideset( crossSet2, 1/2, 1/2 );
    sets = cell(1,3);
    sets{1} = crossSet1;
    sets{2} = crossSet2;
    sets{3} = crossSet3;
    tTrain = 0;
    tTest = 0;
    results = cell(1,3);
    for i = 1:3
        for j = 1:3
            for k = 1:3
                if i ~= j && i ~= k && j ~= k
                    trainSet = [sets{i}; sets{j}];
                    testSet = [sets{k}];
                    tic;
                    nb = NaiveBayes.fit( trainSet(:,1:end-1), trainSet(:,end) );
                    t = toc;
                    tTrain = tTrain + t;
                    tic;
                    results{k} = nb.predict(testSet(:,1:end-1));
                    t = toc;
                    tTest = tTest + t;
                end
            end
        end
    end
    
    input = [sets{1};sets{2};sets{3}];
    results = [results{1}; results{2}; results{3}];

end