function [ average_distance ] = errorHA( points1, points2, transformation )
%ERRORHA Calculates average distance between two sets of corresponding
% points. Translates points1 by transformation first. 
%   Input: points1: 2 x n1 matrix of points
%          points2: 2 x n2 matrix of points
%   points1 and points2 have corresponding rows 
    
    % Select smaller value, assuming something went wrong with the lengths
    n1 = size(points1, 2);
    n2 = size(points2, 2);
    
    if n1 > n2
        n = n2;
    else
        n = n1;
    end
        
    % Transform points1
    new_points1 = zeros(size(points1));
    for index = 1:n
        temp = transformation * [points1(:, index); 1];
        new_points1(:, index) = temp(1:2)/temp(3);
    end
    
    % Euclidean distance between each pair of points.
    diff = new_points1(:, 1:n) - points2(:, 1:n);
    diff = diff .^2;
    diff = sum(diff);
    diff = sqrt(diff);
    
    % Average it out for HA value.
    average_distance = mean(diff);

end

