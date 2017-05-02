%% Question 2 Part 2 Section C 1 Epipolar Lines Tsukuba
clear;
close all;
if ismac
    addpath('../res/kitchen');
    addpath('../res');
    outputpath = ('../');
else
    addpath('res/kitchen');
    addpath('../res');
    outputpath = ('');
end


load('q1_3_d_matches.mat');


%% Load images
imgA = imread('tkb1.pgm');
imgB = imread('tkb5.pgm');

%% Acquire fundamental matrix

F = estFundamentalMat(coordA, coordB);

%% Begin disparity, obtain Windows of A. 
winSize = 5;

% Obtain some limits, pad image. 
rowLim = size(imgA, 1);
colLim = size(imgA, 2);

padRows = winSize - mod(rowLim, winSize);
padCols = winSize - mod(colLim, winSize);

imgAPadded = padarray(imgA, [padRows padCols], 'replicate', 'post');

rowLim = size(imgAPadded, 1);
colLim = size(imgAPadded, 2);

winRows = rowLim/winSize;
winCols = colLim/winSize;

% 2 Arrays for Disparity
disparityX = zeros(winRows, winCols);
disparityY = zeros(winRows, winCols);

imgBPadded = padarray(imgB, [winSize - 1, winSize - 1], 'replicate');

%% Actual processing

% For each window
for winRow = 1:winRows
    for winCol = 1:winCols
        winRowStart = winSize*(winRow-1) + 1;
        winColStart = winSize*(winCol-1) + 1;
        
        % The actual window.
        winA = imgAPadded(winRowStart:winRowStart+winSize-1, winColStart:winColStart+winSize-1);
        
        % The centre.
        xA = winColStart + (winSize/2) - 0.5;
        yA = winRowStart + (winSize/2) - 0.5;
        
        % Epipolar line in B, [a; b; c]. m is -a/b, b is -c/b
        linB = F * [xA; yA; 1];
        m = -linB(1)/linB(2);
        b = -linB(3)/linB(2);
        
        % Values of points of EpiLine in B
        xBSpan = size(imgB, 2);
        yBSpan = size(imgB, 1);
        LineB = [1:xBSpan; m * (1:xBSpan) + b];
        
        % Remove unneccessary points (y < 0, y > max), then round.
        LineB = LineB(:, (LineB(2, :) > 0) & (LineB(2, :) < yBSpan));
        LineB = round(LineB);
        M = size(LineB, 2);
        
        % Store results
        ssd = zeros(1, M);
        
        % For each valid point on epiLine in B associated with point
        if M ~= 0
            for window = 1:M
                % Extract same window
                % Offset
                xB = LineB(1, window) + winSize - 1;
                yB = LineB(2, window) + winSize - 1;
                % Left Upper Corner
                xStart = round(xB - (winSize/2) + 0.5);
                yStart = round(yB - (winSize/2) + 0.5);
                winB = imgBPadded(yStart:yStart+winSize-1, xStart:xStart+winSize-1);

                % SSD
                ssd(window) = sum(sum((double(winA) - double(winB)).^2));
            end
            
            % Extract minimum SSD as match.
            [~, minIndex] = min(ssd);
            xB = LineB(1, minIndex);
            yB = LineB(2, minIndex);
             % Store disparity
            disparityX(winRow, winCol) = xB - xA;
            disparityY(winRow, winCol) = yB - yA;
        else
            disparityX(winRow, winCol) = NaN;
            disparityY(winRow, winCol) = NaN;     
        end
    end
end

%% Plot original and then disparity 
close all;

% Original
figure;
imshow(imgA);
fig = gcf;
fig.PaperPositionMode = 'auto';
print([outputpath, 'pic/q2_2_c1_A'],'-dpng','-r0');

% Disparity
figure;
disparityXBig = imresize(disparityX, winSize, 'Method', 'box');
imshow(disparityXBig, [min(min(disparityXBig)), max(max(disparityXBig))]);
colormap jet;
colorbar;
fig = gcf;
fig.PaperPositionMode = 'auto';
print([outputpath, 'pic/q2_2_c1_dis'],'-dpng','-r0');

%% Depth
figure;
depth = 1 ./ abs(disparityX);
depth = depth * 20e-2 * 24e-3;
depth(depth == Inf | depth == -Inf) = 0;
depth = imresize(depth, winSize, 'Method', 'box');
imshow(depth, [0, 2.5e-4]);
colormap jet;
colorbar;
fig = gcf;
fig.PaperPositionMode = 'auto';
print([outputpath, 'pic/q2_2_c1_depth'],'-dpng','-r0');