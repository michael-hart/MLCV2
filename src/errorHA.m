function [ average_distance ] = errorHA( points1, points2 )
%ERRORHA Calculates average distance between two sets of corresponding
%points
%   Input: points1: n1 x 2 matrix of points
%          points2: n2 x 2 matrix of points
%   points1 and points2 have corresponding rows 
    
    % Select smaller value, assuming something went wrong with the lengths
    n1 = size(points1, 1);
    n2 = size(points2, 1);
    
    if n1 > n2
        n = n2;
    else
        n = n1;
    end
    
    diff = points1(1:n, :) - points2(1:n, :);
    diff = diff .^2;
    diff = sum(diff, 2);
    diff = sqrt(diff);
    
    average_distance = mean(diff);

end

