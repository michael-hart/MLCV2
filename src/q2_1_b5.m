%% Q2 Part 1 Section B
clear;
close all;

if ismac
    addpath('../res/boat');
    addpath('../res');
    addpath('../tes/matches');
    outputpath = ('../');
else
    addpath('res');
    addpath('res/boat');
    % addpath('where matchy results are');
    outputpath = (''); % Wherever you want them
end

for outside = 3:3
    % Acquire image A. 
    imgA = imread(strcat('img', num2str(outside), '.pgm'));

    for inside = outside+1:4
        % Acquire image B.
        
        imgB = imread(strcat('img', num2str(inside), '.pgm'));
        
        loadfilename = strcat('matches_', num2str(outside), '_', num2str(inside),'.mat');
        
        load(loadfilename);
        
        savepicname = strcat('pic/q2_1_b4_', num2str(outside), '_', num2str(inside));
        
        % For my info
        disp(['Outside value: ', num2str(outside), ...
            ' Inside value: ', num2str(inside)]);

        % Visualise matches.
        figure('Visible','off')
        p1 = cornerPoints(coordOptA');
        p2 = cornerPoints(coordOptB');
        showMatchedFeatures(imgA, imgB, p1, p2);
        fig = gcf;
        fig.PaperPositionMode = 'auto';
%         print([outputpath, savepicname, '_matched'],'-dpng','-r0');

        % Transform and project
        transformMat = estTransformMat(coordOptA, coordOptB);
        [imgAB, refAB] = projection(imgA, transformMat);
%         transformMatABObj = projective2d(transformMat2');
%         [imgAB, refAB] = imwarp(imgA, transformMatABObj);
        
        % Visualise new image and overlay
        figure('Visible','off')
        imshow(imgAB);
        fig = gcf;
        fig.PaperPositionMode = 'auto';
%         print([outputpath, savepicname, '_transformed'],'-dpng','-r0');
    
        figure('Visible','on', 'position', [0 0 1280 800])
        imshowpair(imgB, imref2d(size(imgB)), imgAB, refAB);
        fig = gcf;
        fig.PaperPositionMode = 'auto';
%         print([outputpath, savepicname, '_pair'],'-dpng','-r0');
    end
end

