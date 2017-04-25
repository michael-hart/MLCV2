function [ coordOptA, coordOptB ] = optimise( coordA, coordB )
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
    
    while (unoptimised)
        % Storage and baseline
        useful = false(1, oldTotal);
        transformBase = estTransformMat(coordOptA, coordOptB);    
        baseError = errorHA(coordOptA, coordOptB, transformBase);
        
        % Each point
        for index = 1:oldTotal
            tempCoordA = coordOptA;
            tempCoordB = coordOptB;
            % Remove from list
            tempCoordA(:, index) = [];
            tempCoordB(:, index) = [];

            % Recalculate transform and error
            transform = estTransformMat(tempCoordA, tempCoordB);
            error = errorHA(tempCoordA, tempCoordB, transform);

            % If it increases the error, it is useful
            if error > baseError
                useful(index) = true;
            end
        end
    
        % Check new values
        newTotal = sum(useful);
        
        % Only reduce if possible or if less. 
        if (newTotal > 3 && newTotal ~= oldTotal)
            % Reduced
            coordOptA = coordOptA(:, useful);
            coordOptB = coordOptB(:, useful);
            oldTotal = newTotal;
        else
            unoptimised = false;
        end
    end
end

