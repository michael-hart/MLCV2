%% Q2 Part 1 Section B
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

%%

for index = 1:5
    nameIn = ['tkb', num2str(index), '.ppm'];
    img = imread(nameIn);
    imggray = rgb2gray(img);
    nameOut = ['../res/tsukuba/tkb', num2str(index), '.pgm'];
    imwrite(imggray, nameOut);
end
