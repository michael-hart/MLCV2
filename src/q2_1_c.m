%% Q2 Part 1 Section C

clear;
close all;

if ismac
    addpath('../res/kitchen');
    addpath('../res');
    addpath('../tes/test2');
    outputpath = ('../');
else
    addpath('res');
    addpath('res/kitchen');
    outputpath = ('');
end

imgA = imread('HG1.pgm');
imgB = imread('HG2.pgm');
imgC = imread('HG3.pgm');

load('20020020064coord.mat');
load('20020020064ransaccoord.mat');
%% Processing
N = size(coordBC_AOpt,2);

errors = zeros(1, N-3);

for number = 4:N
    indices = datasample(1:N, number, 2);
    coordBC_AOpt_Selected = coordBC_AOpt(:, indices);
    coordBC_BOpt_Selected = coordBC_BOpt(:, indices);
    transformMat = estTransformMat(coordBC_AOpt_Selected, coordBC_BOpt_Selected);
    errors(number) = errorHA(coordBC_AOpt_Selected, coordBC_BOpt_Selected, transformMat);
end

figure('position', [0 0 1280 800]);
plot(1:N, errors, 'LineWidth', 5);
axis([0 N 0 ceil(max(errors)/10) * 10]);

title('HA Error vs. Number of Corresponding Points', 'interpreter', 'latex');
xlabel('Number of Corresponding Points', 'interpreter', 'latex');
ylabel('HA Error', 'interpreter', 'latex');
grid;

% Format data
set(findall(gcf,'type','axes'),'fontsize',25);
set(findall(gcf,'type','text'),'fontSize',25);
% Save data
fig = gcf;
fig.PaperPositionMode = 'auto';
print([outputpath, 'pic/q2_1_c'],'-dpng','-r0');

