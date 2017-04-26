function [ coordOptA, coordOptB ] = optimise3( coordA, coordB)
%OPTIMISE Remove outliers from coordinate pairs
%   IN: coordA, coordB. 2xN
%   OUT: coordAOpt, coordBOpt, 2xM

    % Constants
    N = size(coordA, 2);
    
    % Combinations
    combo = combnk(1:N, 4);
    M = size(combo, 1);
    
    % Storage
    errors = zeros(1, M);
    
    for m = 1:M
        tempA = coordA(:, combo(m, :));
        tempB = coordB(:, combo(m, :));
        transformMat = estTransformMat(tempA, tempB);
        errors(m) = errorHA(tempA, tempB, transformMat);
    end
    
    % Check for best
    [~, minIndex] = min(errors);
    coordOptA = coordA(:, combo(minIndex, :));
    coordOptB = coordB(:, combo(minIndex, :));

        
end

