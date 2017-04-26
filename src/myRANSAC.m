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
    maxSize = 0;
    
    coordOptA = coordA;
    coordOptB = coordB;

    for iter = 1:iterations
        % 1. Randomly select 4. 
        samples = datasample(1:N, 4);
        coordASamples = coordA(:, samples);
        coordBSamples = coordB(:, samples);
        
        % 2. Homography
        transformMat = estTransformMat(coordASamples, coordBSamples);

        % 3. Extract inliers
        % 3. 1 Calculate distances
            % Transform coordA
            transCoordA = zeros(size(coordA));
            for index = 1:N
                temp = transformMat * [coordA(:, index); 1];
                transCoordA(:, index) = temp(1:2);
            end
    
            % Euclidean distance between each pair of points.
            diff = transCoordA - coordB;
            diff = sqrt(sum(diff .^2));

        % 3. 2 Extract those under epsilon (diff < epsilon)
                % ONLY IF the size of the inliers is more than before

            if (sum(diff < epsilon) > maxSize)
                coordOptA = coordA(:, diff < epsilon);
                coordOptB = coordB(:, diff < epsilon);
                maxSize = size(coordOptA, 2);
            end
            
        
    end
end

