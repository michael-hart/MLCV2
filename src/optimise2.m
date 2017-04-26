function [ coordOptA, coordOptB ] = optimise2( coordA, coordB, ratio)
%OPTIMISE Remove outliers from coordinate pairs
%   IN: coordA, coordB, transform. 2xN
%   OUT: coordAOpt, coordBOpt, 2xM
%   Error of overall calculated. Then, one by one, each point is removed.
%   Error recalculated, if more, then point is necessary. If less, point is
%   outlier. 
%   Outliers removed, new set.

    % Constants
    N = size(coordA, 2);
    unoptimised = true;
    oldTotal = N;
    
    % Preample
    coordOptA = coordA;
    coordOptB = coordB;
    
    while (unoptimised && oldTotal > 3 && oldTotal > ratio * N)
        disp('-');
        % Storage and baseline
        error = zeros(1, oldTotal);
%         transformBase = estTransformMat(coordOptA, coordOptB);    
        baseError = errorHA(coordOptA, coordOptB, eye(3));
        disp(baseError);
        % Each point
        for index = 1:oldTotal
            tempCoordA = coordOptA;
            tempCoordB = coordOptB;
            % Remove from list
            tempCoordA(:, index) = [];
            tempCoordB(:, index) = [];

            % Recalculate transform and error
            transform = estTransformMat(tempCoordA, tempCoordB);
            error(index) = errorHA(tempCoordA, tempCoordB, transform);
        end
    
        % Check new values
        if sum(error < baseError) < 1
            disp('Done.');
            unoptimised = false;
        else
            disp('Removing.');
            [minVal, minIndex] = min(error);
            disp(minVal);
            coordOptA(:, minIndex) = [];
            coordOptB(:, minIndex) = [];
            oldTotal = oldTotal - 1;
        end
        
    end
end

