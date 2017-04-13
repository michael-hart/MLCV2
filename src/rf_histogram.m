function [ histo ] = rf_histogram(features, trees)
    % Quantisation function
    num_trees = size(trees,2);
    num_features = size(features,2);
    data_in = zeros(num_trees, num_features);
    max_leaves = trees(size(trees,2)).leaf(end).label;
    
    % Run for each image. The features are passed through the trees. Their
    % resultant end nodes are compiled, before being made into a histogram
    % vector.
    for feature_idx = 1:size(features,2)
        data_in(:, feature_idx) = testTrees([features(:, feature_idx); 0]', trees);
    end
    
    histo = histogramoutput(data_in(:), max_leaves);
end

