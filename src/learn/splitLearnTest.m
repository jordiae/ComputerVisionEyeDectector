function [learn,test] = splitLearnTest(data)
    [nrows,~] = size(data);
    indexLearn = randsample(1:nrows,floor(nrows*0.7));
    indexTest = setdiff(1:nrows,indexLearn);
    learn = data(indexLearn,:);
    test = data(indexTest,:);
end