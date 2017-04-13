%% Preamble
clear;
close all;

% addpaths.
addpath('../rf2017/internal');
addpath('../rf2017/external');
addpath('../rf2017/external/libsvm-3.18/matlab');


% Load data
load('q3.mat', 'data_train', 'data_test', 'train_index_output', 'test_index_output', 'sift_features');


%% Grow Trees

for t_num = [2, 6]
    for t_dep = [2, 6]

        % Set the random forest parameters

        param.num = t_num;         % Number of trees
        param.depth = t_dep;        % trees depth
        param.splitNum = 50;     % Number of split functions to try
        param.split = 'IG';     % Currently support 'information gain' only
        param.split_func = 'axis-aligned';
        tic;
        trees = growTrees([sift_features; zeros(1, 1e5)]', param);
        disp(toc);
        %% Quantise each picture training
        max_leaves = trees(size(trees,2)).leaf(end).label;
        histogram_outputs_train = zeros(10 * 15, max_leaves + 1);
        output_idx = 1;

        for class_idx = 1:10
            for image_idx = 1:15
                histogram_outputs_train(output_idx, 1:max_leaves) = ...
                    rf_histogram(data_train{class_idx, image_idx}, trees);
                histogram_outputs_train(output_idx, max_leaves+1) = class_idx;
                output_idx = output_idx + 1;
            end
        end

        %% Quantise each picture testing
        max_leaves = trees(size(trees,2)).leaf(end).label;
        output_idx = 1;
        histogram_outputs_test = zeros(10 * 15, max_leaves + 1);

        for class_idx = 1:10
            for image_idx = 1:15
                histogram_outputs_test(output_idx, 1:max_leaves)...
                    = rf_histogram(data_test{class_idx, image_idx}, trees);
                output_idx = output_idx + 1;
            end
        end

        %% Grow Trees for Classification

        % Set the random forest parameters

        param.num = 8;         % Number of trees
        param.depth = 10;        % trees depth
        param.splitNum = 50;     % Number of split functions to try
        param.split = 'IG';     % Currently support 'information gain' only
        param.split_func = 'axis-aligned';

        trees_class = growTrees(histogram_outputs_train, param);

        %% Testing
        for n=1:size(histogram_outputs_test,1)
            leaves = testTrees(histogram_outputs_test(n,:), trees_class);
            p_rf = trees_class(1).prob(leaves,:);
            p_rf_sum = sum(p_rf)/length(trees_class);
            [~, guess] = max(p_rf_sum);
            histogram_outputs_test(n, end) = guess;
        end

        %% Confusion matrix. 
        % Save the image file (edit title) and outputs.
        filename = strcat('rfrf', num2str(t_num), num2str(t_dep));
        [indices, class_actual, class_guesses, percentage] = results(histogram_outputs_test(:, end), histogram_outputs_train(:, end), 'RF Codebook', filename);
    end
end