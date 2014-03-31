function [ trainSet, testSet ] = divideset( data, perTrain, perTest )
%DIVIDESET Randomly splits data into two sets, a training and test set,
%based on the percentage train and percentage test parameters.  perTrain
%and perTest must add to 1.

if perTrain + perTest ~= 1
    error( 'ERROR! Training and Test percentage must add to 100\n' );
end

[n,m] = size(data);

nTrain = round(perTrain * n);
nTest = n - nTrain;

trainSet = zeros(nTrain, m);
testSet = zeros(nTest, m);

testIndex = 1;

state = zeros(1,n);     %States array, 0 = unused, 1 = test, 2 = train
while testIndex <= nTest
    index = round(rand * (n-1) + 1);
    if state(index) == 0
        state(index) = 1;
        testSet(testIndex,:) = data(index,:);
        testIndex = testIndex + 1;
    end
end
trainSet(:,:) = data( state(:) == 0, : );

end

