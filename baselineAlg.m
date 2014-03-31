function [testRes, tTrain, tTest] = baselineAlg( trainSet, testSet )
    

    %svmStruct = svmtrain( trainSet(:,1:end-1), trainSet(:,end));
    nb = NaiveBayes.fit( trainSet(:,1:end-1), trainSet(:,end) );

    %testRes = svmclassify( svmStruct, testSet(:,1:end-1), 'method', 'SMO', 'options', 'MaxIter', 1e9, 'kktviolationlevel', 0.05, 'tolkkt', 1e-2 );
    %testRes = round( testRes );
    testRes = nb.predict(testSet(:,1:end-1));
    tTrain = 0;
    tTest = 0;

end