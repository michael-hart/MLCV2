function [ imgATransformed, ref ] = projection( imgA, transform )
%PROJECTERROR New transformed image.
%   Detailed explanation goes here
    
    % Constants
    height = size(imgA, 1);
    width = size(imgA, 2);
    
    % Holding for transformed points and values.
    output = zeros(3, height * width);
    
    counter = 0;
    
    % Cycle through. Each point in originals is transformed. 
    % New location stored. Old colour value kept. 
    for row = 1:height
        for col = 1: width
            temp = transform * [col; row; 1];
            counter = counter + 1;
            output(:, counter) = [temp(1:2)/temp(3); double(imgA(row, col))];
        end
    end

    % Create output variable
    maxRows = max(output(2, :));
    minRows = min(output(2, :));
    totalRows = round(maxRows) - round(minRows) + 1;
    
    maxCols = max(output(1, :));
    minCols = min(output(1, :));
    totalCols = round(maxCols) - round(minCols) + 1;
    
    % Reference data required for plotting together. 
    ref = imref2d([totalRows, totalCols]);
    ref.XWorldLimits = [minCols, maxCols];
    ref.YWorldLimits = [minRows, maxRows];
    
    imgATransformed = uint8(zeros(totalRows, totalCols));
    % Populate
    for index = 1:size(output, 2)
        X = output(1, index);
        Y = output(2, index);
        colour = output(3, index);
        X = round(X - minCols) + 1;
        Y = round(Y - minRows) + 1;
        imgATransformed(Y, X) = colour;
    end
    
end

