function [ coordOptA, coordOptB ] = optimise2( coordA, coordB )
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
    
    while (unoptimised && oldTotal > 4 && oldTotal > 0.3 * N)
        % Storage and baseline
        error = zeros(1, oldTotal);
        transformBase = estTransformMat(coordOptA, coordOptB);    
        baseError = errorHA(coordOptA, coordOptB, transformBase);
        disp(['baseError: ', num2str(baseError)]);
        
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
        disp(['error: ', num2str(error)]);
        if sum(error > baseError) < 1
            unoptimised = false;
        else
            [~, minIndex] = min(error);
            disp(['Removing ', num2str(minIndex)]);
            coordOptA(:, minIndex) = [];
            coordOptB(:, minIndex) = [];
            oldTotal = oldTotal - 1;
            fprintf('\n');
        end
        
    end
end

