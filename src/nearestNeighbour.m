function [ neighbours ] = nearestNeighbour( A, B )
%NEARESTNEIGHBOUR Returns point in B that is closed to point in A
%   A and B are 2 x n and 2 x m respectively.
%   Returns neighbours, which is n x 2 of nearest row in B to each row in A
    % Constants
    n = size(A, 2);
    m = size(B, 2);
    
    % Output
    neighbours = zeros(2, n);
    
    for index = 1:n
        % Replicate row in A, m times.
        working = repmat(A(:, index), 1, m);
        % So can subtract B. Each row is difference. 
        working = working - B;
        % Square, sum, sqrt, for Euclidean distance.
        working = working .^2;
        distances = sum(working);
        distances = sqrt(distances);
        % Find index of minimum value.
        [~, nearest] = min(distances);
        % Nearest neighbour of point in A is that index in B
        neighbours(:, index) = B(:, nearest);
    end

end

