%% Question 2 Part 1 Section A
clear;
close all;
if ismac
    addpath('../res/kitchen');
    outputpath = ('../');
else
    addpath('res/kitchen');
    outputpath = ('');
end

%% Generate data to use, normal image
imgNormal = imread('HG1.pgm');

% Perform Harris corner detection - 2500 works well from testing
harrisNormal = harris(imgNormal, 500);

%% Display picture with points
figure;
imshow(imgNormal);
hold on;
scatter(harrisNormal(1, :), harrisNormal(2, :), 50, 'x', 'MarkerEdgeColor', 'blue');
hold off;
fig = gcf;
fig.PaperPositionMode = 'auto';
print([outputpath, 'pic/q2_1_a_imgNormal'],'-dpng','-r0');

%% Generate data to use, reduced image
imgReduced = imresize(imgNormal, 0.5);

% Perform Harris corner detection - 2500 works well from testing
harrisReduced = harris(imgReduced, 500);

%% Display picture with points
figure;
imshow(imgReduced);
hold on;
scatter(harrisReduced(1, :), harrisReduced(2, :), 50, 'x', 'MarkerEdgeColor', 'blue');
hold off;
fig = gcf;
fig.PaperPositionMode = 'auto';
print([outputpath, 'pic/q2_1_a_imgReduced'],'-dpng','-r0');

%% Display both sets of points together.
% Normal image, with reduced points doubled to fit. 
figure;
imshow(imgNormal);
hold on;
scatter(harrisNormal(1, :), harrisNormal(2, :), 50, 'o', 'filled', 'blue');
scatter(2 * harrisReduced(1, :), 2 * harrisReduced(2, :), 50, 'x', 'MarkerEdgeColor', 'green');
hold off;
fig = gcf;
fig.PaperPositionMode = 'auto';
print([outputpath, 'pic/q2_1_a_imgBoth'],'-dpng','-r0');

%% Match patches in same way, just use coordinates instead of features.
[matches] = matchPatches(harrisNormal, 2 * harrisReduced);

nMatch = size(matches, 2);
total = 0;

% Locate each pair, take distance. Sum. Then average. 
for index= 1:nMatch
    n = matches(1, index);
    m = matches(2, index);
    p1 = harrisNormal(:, n);
    p2 = 2 * harrisReduced(:, m);
    distance = sum((p1 - p2).^2).^0.5;
    total = total + distance;
end

total = total/nMatch;
disp(total)
