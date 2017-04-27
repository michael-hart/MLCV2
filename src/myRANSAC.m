function [ coordOptA, coordOptB ] = myRANSAC( coordA, coordB, iterations, epsilon )
%MYRANSAC Remove outliers from coordinate pairs
%   IN: coordA, coordB, iterations, epsilon. 2xN
%   OUT: coordAOpt, coordBOpt, 2xM
%   How? From http://6.869.csail.mit.edu/fa12/lectures/lecture13ransac/lecture13ransac.pdf
%   1. Select four feature pairs (at random)
%   2. Compute homography H (exact)
%   3. Compute inliers:
%         where transformed points are < eps of their equivalent
%   4. Keep largest set of inliers
    
    % Constants
    N = size(coordA, 2);
    
    samples = zeros(iterations, 4);
    inlierSize = zeros(iterations, 1);

    parfor iter = 1:iterations
        % 1. Randomly select 4. 
        sample = datasample(1:N, 4);
        samples(iter, :) = sample;
        
        coordASamples = coordA(:, sample);
        coordBSamples = coordB(:, sample);
        
        % 2. Homography
        transformMat = estTransformMat(coordASamples, coordBSamples);

        % 3. Extract inliers
        % 3. 1 Calculate distances
            % Transform coordA
            transCoordA = zeros(size(coordA));
            for index = 1:N
                temp = transformMat * [coordA(:, index); 1];
                transCoordA(:, index) = temp(1:2)/temp(3);
            end
    
            % Euclidean distance between each pair of points.
            diff = transCoordA - coordB;
            diff = sqrt(sum(diff .^2));
        
        % 3. 2 Count those in range
            inlierSize(iter) = sum(diff < epsilon);
    end
    
    % 4. Find random sample with largest size of inliers.
    [~, iterIndex] = max(inlierSize);
    
    % 5. Acquire inliers.
    coordASamples = coordA(:, samples(iterIndex, :));
    coordBSamples = coordB(:, samples(iterIndex, :));
        
    % Homography
    transformMat = estTransformMat(coordASamples, coordBSamples);

    % Transform coordA
    transCoordA = zeros(size(coordA));
    for index = 1:N
        temp = transformMat * [coordA(:, index); 1];
        transCoordA(:, index) = temp(1:2)/temp(3);
    end
    
    % Euclidean distance between each pair of points.
    diff = transCoordA - coordB;
    diff = sqrt(sum(diff .^2));
        
    % Extract those in range.
    coordOptA = coordA(:, diff < epsilon);
    coordOptB = coordB(:, diff < epsilon);
            
end

