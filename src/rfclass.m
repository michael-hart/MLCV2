%% Grow Trees

% Set the random forest parameters

param.num = 3;         % Number of trees
param.depth = 13;        % trees depth
param.splitNum = 50;     % Number of split functions to try
param.split = 'IG';     % Currently support 'information gain' only
param.split_func = 'axis-aligned';

trees = growTrees(data_trees_train, param);

%% Testing
for n=1:size(data_trees_test,1)
    leaves = testTrees(data_trees_test(n,:), trees);
    p_rf = trees(1).prob(leaves,:);
    p_rf_sum = sum(p_rf)/length(trees);
    [~, guess] = max(p_rf_sum);
    data_trees_test(n, k+1) = guess;
end