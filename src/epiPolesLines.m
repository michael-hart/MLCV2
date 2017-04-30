function [ epiLines, epiPole ] = epiPolesLines( coord, F, baseLine )
%EPIPOLESLINES Takes Fundamental matrix, coordinates, finds epipoles/lines.
%   In: Coord of points in Img (2 x N)
%       Fundamental matrix (3 x 3)
%       baseline (camera movement) 1 x 2 or 2 x 1 (Xdisp, Ydisp)
%       imgSize 1 x 2 or 2 x 1, (rows, cols) = (Y, X). 
%   Out: epiPole, 3 x 1, and lines (in m, x form) N x 2

    % xb' * F * eA = 0, F * eA = 0, so SVD (F) like before. ;
    [~, ~, V] = svd(F);
    epiPole = V(:, end)/(V(end, end));
    % Normalise since epiPole is on same plane as picture.
    
    N = size(coord, 2);
    Xdisp = baseLine(1);
    Ydisp = baseLine(2);
    
    % Output in form n x 2. [m x] for each row where y = mx + b
    epiLines = zeros(N, 2);
        
    % Check if epiPole is possible.
    if sum(isfinite(epiPole)) ~= 3
        epiPole = [NaN, NaN, NaN];
        % If the horizontal movement is less than vertical
        % Camera moved up/down, hence lines vertical.
        if Xdisp < Ydisp
            for index = 1:N
                xA = coord(1, index);
                epiLines(index, :) = [1 0 -xA];
            end
        % If horizontal is more, then camera moved left/right, horizontal.
        else
            for index = 1:N
                yA = coord(2, index);
                epiLines(index, :) = [0 1 -yA];
            end
        end
    % If lines not parallel
    else
        for index = 1:N
            x1 = coord(1, index);
            y1 = coord(2, index);

            x2 = epiPole(1);
            y2 = epiPole(2);

            m = (y2 - y1)/(x2 - x1);
            b = y2 - m * x2;
            epiLines(index, :) = [m, b];
        end
    end
    
end

