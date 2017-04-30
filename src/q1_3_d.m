%% Q1 Part 3 Section D
clear;
close all;

if ismac
    addpath('../res/tsukuba');
    addpath('../res');
    outputpath = ('../');
else
    addpath('res');
    addpath('res/tsukuba');
    outputpath = ('');
end

%% Attempt to match?
newPoints = true;

if newPoints
    [coordA, coordB] = q1_manual('tkb1.pgm', 'tkb5.pgm');
    close all;
    save([outputpath, 'res/q1_3_d_matches.mat'], ...
        'coordA', 'coordB');
else
    load('q1_3_d_matches.mat');
end

%% Load images
imgA = imread('tkb1.pgm');
imgB = imread('tkb5.pgm');

%% Calculate F, epipoles, lines, 
F = estFundamentalMat(coordA, coordB);
[epiLines, epiPole] = epiPolesLines(coordA, F, [NaN NaN]);
disp(epiPole);

%% Calculate lines.
imgWidth = size(imgA, 2);
N = size(epiLines, 1);

xpoints = repmat(1:imgWidth, N, 1)';

ypoints = zeros(imgWidth, N);
for index = 1:N
    ypoints(:, index) = [1:imgWidth]' .* epiLines(index, 1) + epiLines(index, 2);
end

%% Plot it all
figure;
imshow(imgA);
hold on;
plot(xpoints, ypoints);
scatter(coordA(1, :), coordA(2, :), 50, 'filled', 'g');
hold off;
fig = gcf;
fig.PaperPositionMode = 'auto';
print([outputpath, 'pic/q1_3_d_A'],'-dpng','-r0');


%% Repeat on B
% Transpose F to fix. 
[epiLines, epiPole] = epiPolesLines(coordB, F', [NaN NaN]);
disp(epiPole);

imgWidth = size(imgB, 2);
N = size(epiLines, 1);

xpoints = repmat(1:imgWidth, N, 1)';

ypoints = zeros(imgWidth, N);
for index = 1:N
    ypoints(:, index) = [1:imgWidth]' .* epiLines(index, 1) + epiLines(index, 2);
end

%% Plot it all
figure;
imshow(imgB);
hold on;
plot(xpoints, ypoints);
scatter(coordB(1, :), coordB(2, :), 50, 'filled', 'g');
hold off;
fig = gcf;
fig.PaperPositionMode = 'auto';
print([outputpath, 'pic/q1_3_d_B'],'-dpng','-r0');

