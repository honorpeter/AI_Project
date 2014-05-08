function [testRes, tTrain, tTest, testSet] = svmAlg( dataSet )
%SVMALG Summary of this function goes here
%   Detailed explanation goes here
    for i = 1:(size(dataSet, 2) - 1)
        [dataSet(:,i), M, s] = normalize( dataSet(:,i) );
    end
    options = optimset('maxiter',100000);
    [trainSet, testSet] = divideset( dataSet, 0.6, 0.4 );
    sigma = 1;
    tic;
    svmStruct = svmtrain( trainSet(:,1:end-1), trainSet(:,end), ...
                            'kernel_function','mlp', ...
                            'options',options);
    tTrain = toc;
    
    tic;   
    testRes = svmclassify(svmStruct, testSet(:,1:end-1));
    for i = numel(testRes)
        if testRes(i) > 0
            testRes(i) = 1;
        else
            testRes(i) = -1;
        end
    end
    tTest = toc;
end

