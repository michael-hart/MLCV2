%% Question 2 Part 1 Section A and B
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

newPoints = false;

if newPoints 
    [coordA, coordB] = q1_manual_9('FD1.pgm', 'FD2.pgm');
    [~, coordC] = q1_manual_9('FD2.pgm', 'FD3.pgm');
    save([outputpath, 'res/q2_2_a.mat'], ...
        'coordA', 'coordB', 'coordC');
else
    load('q2_2_a.mat');
end

imgA = imread('FD1.pgm');
imgB = imread('FD2.pgm');

%% Choosing which combination
choice = 0;

if choice == 1
    coordA = coordB;
    coordB = coordC;
    imgA = imread('FD2.pgm');
    imgB = imread('FD3.pgm');
end

if choice == 2
    temp = coordC;
    coordC = coordA;
    coordA = temp;
    imgA = imread('FD3.pgm');
    imgB = imread('FD1.pgm');
end
    

%% Display matching.
figure('position', [0 0 1280 800]);
p1 = cornerPoints(coordA');
p2 = cornerPoints(coordB');
showMatchedFeatures(imgA, imgB, p1, p2);
fig = gcf;
fig.PaperPositionMode = 'auto';
print([outputpath, 'pic/q2_2_ab_match_', num2str(choice)],'-dpng','-r0');

%% Acquire fundamental matrix. Acquire epipole and lines. Plot. For A vs. B

F = estFundamentalMat(coordA, coordB);
[epiLinesA, epiLinesB, epiPole] = epiPolesLines(coordA, F, [NaN NaN]);

% Calculate lines. 
imgWidth = size(imgA, 2);
N = size(epiLinesA, 1);

xpoints = repmat(1:imgWidth, N, 1)';

ypointsA = zeros(imgWidth, N);
for index = 1:N
    ypointsA(:, index) = [1:imgWidth]' .* epiLinesA(index, 1) + epiLinesA(index, 2);
end

ypointsB = zeros(imgWidth, N);
for index = 1:N
    ypointsB(:, index) = [1:imgWidth]' .* epiLinesB(index, 1) + epiLinesB(index, 2);
end

% Plot
figure('position', [0 0 1280 800]);
imshow([imgA imgB]);
title(['Epipole A location: ', num2str(epiPole')]);
hold on;
% Lines
plot(xpoints, ypointsA, 'b');
plot(xpoints + imgWidth, ypointsB, 'g');
% Points
scatter(coordA(1, :), coordA(2, :), 50, 'o', 'filled', 'b');
scatter(coordB(1, :)+ imgWidth, coordB(2, :), 50, 'o', 'filled', 'g');
% Numbering
text(coordA(1, :), coordA(2, :), num2cell(1:9), 'FontSize', 20, 'color', 'g');
text(coordB(1, :)+ imgWidth, coordB(2, :), num2cell(1:9), 'FontSize', 20, 'color', 'b');
hold off;
% Format and saving
set(findall(gcf,'type','text'),'fontSize',25);
set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.
fig = gcf;
fig.PaperPositionMode = 'auto';
print([outputpath, 'pic/q2_2_ab_A_', num2str(choice)],'-dpng','-r0');

%% Acquire fundamental matrix. Acquire epipole and lines. Plot. For B vs. A
[epiLinesA, epiLinesB, epiPole] = epiPolesLines(coordB, F', [NaN NaN]);

% Calculate lines. 
imgWidth = size(imgB, 2);
N = size(epiLinesA, 1);

xpoints = repmat(1:imgWidth, N, 1)';

ypointsA = zeros(imgWidth, N);
for index = 1:N
    ypointsA(:, index) = [1:imgWidth]' .* epiLinesA(index, 1) + epiLinesA(index, 2);
end

% Plot
figure('position', [0 0 1280 800]);
imshow([imgB imgA]);
title(['Epipole B location: ', num2str(epiPole')]);
hold on;
% Lines
plot(xpoints, ypointsA, 'b');
plot(xpoints + imgWidth, ypointsB, 'g');
% Points
scatter(coordA(1, :), coordA(2, :), 50, 'o', 'filled', 'b');
scatter(coordB(1, :)+ imgWidth, coordB(2, :), 50, 'o', 'filled', 'g');
% Numbering
text(coordA(1, :), coordA(2, :), num2cell(1:9), 'FontSize', 20, 'color', 'g');
text(coordB(1, :)+ imgWidth, coordB(2, :), num2cell(1:9), 'FontSize', 20, 'color', 'b');
hold off;
% Formatting and saving
set(findall(gcf,'type','text'),'fontSize',25);
set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.
fig = gcf;
fig.PaperPositionMode = 'auto';
print([outputpath, 'pic/q2_2_ab_B_', num2str(choice)],'-dpng','-r0');
