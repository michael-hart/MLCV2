%% Question 2 Part 2 Section E
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


load('q2_2_d.mat');
imgA = imread('FD1.pgm');
winSize = 10;

%% Processing
% Depth, focal length 2mm more.
figure;

baseline = 20e-2;
focallength = 26e-3;

depth = 1 ./ abs(disparityX);
depth = depth * baseline * focallength;

depth(depth == Inf | depth == -Inf) = 0;
depth = imresize(depth, winSize, 'Method', 'box');
imshow(depth, [0, 1.5e-4]);
colormap jet;
colorbar;
fig = gcf;
fig.PaperPositionMode = 'auto';
print([outputpath, 'pic/q2_2_e_focal1'],'-dpng','-r0');

%% Depth, focal length 2mm less.

figure;

baseline = 20e-2;
focallength = 22e-3;

depth = 1 ./ abs(disparityX);
depth = depth * baseline * focallength;

depth(depth == Inf | depth == -Inf) = 0;
depth = imresize(depth, winSize, 'Method', 'box');
imshow(depth, [0, 1.5e-4]);
colormap jet;
colorbar;
fig = gcf;
fig.PaperPositionMode = 'auto';
print([outputpath, 'pic/q2_2_e_focal2'],'-dpng','-r0');

%% Depth, Gaussian noise added to Disparity. Zero Mean,
% No more than 2 pixels... since most lies within 3 std of mean...
% Standard deviation should be 2/3. Cap at max 2 for values. 

figure;

baseline = 20e-2;
focallength = 24e-3;

% Add noise
themax = 50;
noise = randn(size(disparityX)) * (themax/3);
noise(noise > themax) = themax;
noise(noise < -themax) = -themax;
disparityXNoise = disparityX + noise;

%
close all;
depth = 1 ./ abs(disparityXNoise);
depth = depth * baseline * focallength;

depth(depth == Inf | depth == -Inf) = 0;
depth = imresize(depth, winSize, 'Method', 'box');
imshow(depth, [0, 1.5e-4]);
colormap jet;
colorbar;
fig = gcf;
fig.PaperPositionMode = 'auto';
print([outputpath, 'pic/q2_2_e_gaussian'],'-dpng','-r0');
