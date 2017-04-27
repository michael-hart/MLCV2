%% Question 2 Part 1 Section A
clear;
close all;
if ismac
    addpath('../res/kitchen');
    outputpath = ('../pic/');
else
    addpath('res/kitchen');
    outputpath = ('pic/');
end

%% Generate data to use, normal image
imgNormal = imread('HG1.pgm');

% Perform Harris corner detection - 2500 works well from testing
harrisNormal = harris(imgNormal, 1000);

%% Display picture with points
figure;
imshow(imgNormal);
hold on;
scatter(harrisNormal(1, :), harrisNormal(2, :), 50, 'x', 'MarkerEdgeColor', 'blue');
hold off;
fig = gcf;
fig.PaperPositionMode = 'auto';
print([outputpath, 'q2_1_a_imgNormal'],'-dpng','-r0');

%% Generate data to use, reduced image
imgReduced = imresize(imgNormal, 0.5);

% Perform Harris corner detection - 2500 works well from testing
harrisReduced = harris(imgReduced, 1000);

%% Display picture with points
figure;
imshow(imgReduced);
hold on;
scatter(harrisReduced(1, :), harrisReduced(2, :), 50, 'x', 'MarkerEdgeColor', 'blue');
hold off;
fig = gcf;
fig.PaperPositionMode = 'auto';
print([outputpath, 'q2_1_a_imgReduced'],'-dpng','-r0');

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
print([outputpath, 'q2_1_a_imgBoth'],'-dpng','-r0');

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

% %% Compare
% % Nearest reduced point to actual point
% [ harrisCompare1 ] = nearestNeighbour(harrisNormal, 2 * harrisReduced);
% % Nearest actual point to reduced point
% [ harrisCompare2 ] = nearestNeighbour(2 * harrisReduced, harrisNormal);
% 
% % The two errors
% error1 = errorHA(harrisNormal, harrisCompare1, eye(3));
% error2 = errorHA( 2*harrisReduced, harrisCompare2, eye(3));
% 
% % The average
% disp(mean([error1 error2]));
