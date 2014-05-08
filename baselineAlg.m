function [testRes, tTrain, tTest, testSet] = baselineAlg( dataSet )
    
    [trainSet, testSet] = divideset( dataSet, 0.6, 0.4 );
    %svmStruct = svmtrain( trainSet(:,1:end-1), trainSet(:,end));
    tic
    nb = NaiveBayes.fit( trainSet(:,1:end-1), trainSet(:,end) );
    toc
    %testRes = svmclassify( svmStruct, testSet(:,1:end-1), 'method', 'SMO', 'options', 'MaxIter', 1e9, 'kktviolationlevel', 0.05, 'tolkkt', 1e-2 );
    %testRes = round( testRes );
    tic
    testRes = nb.predict(testSet(:,1:end-1));
    toc
    tTrain = 0;
    tTest = 0;

end