function [] = test(hA, hB, hC, bins)
    if ismac
        addpath('../res/kitchen');
        addpath('../res');
        outputpath = ('../res/');
    else
        addpath('res/kitchen')
        addpath('res');
        outputpath = ('res/');
    end

    imgA = imread('HG1.pgm');
    imgB = imread('HG2.pgm');
    imgC = imread('HG3.pgm');

    showImg = true;

    %% Harris pictures
    harrisA = harris(imgA, hA);
    harrisB = harris(imgB, hB);
    harrisC = harris(imgC, hC);

    %% Extract, quantise
    describeA = describe3(imgA, harrisA, bins);
    describeB = describe3(imgB, harrisB, bins);
    describeC = describe3(imgC, harrisC, bins);

    %% Match
    matchesAB = matchPatches(describeA, describeB);
    matchesBC = matchPatches(describeB, describeC);
    matchesCA = matchPatches(describeC, describeA);

    nMatchAB = size(matchesAB, 2);
    coordAB_A = zeros(2, nMatchAB);
    coordAB_B = zeros(2, nMatchAB);

    for index=1:nMatchAB
        n = matchesAB(1, index);
        m = matchesAB(2, index);
        coordAB_A(:, index) = harrisA(:, n);
        coordAB_B(:, index) = harrisB(:, m);
    end

    nMatchBC = size(matchesBC, 2);
    coordBC_A = zeros(2, nMatchBC);
    coordBC_B = zeros(2, nMatchBC);

    for index=1:nMatchBC
        n = matchesBC(1, index);
        m = matchesBC(2, index);
        coordBC_A(:, index) = harrisB(:, n);
        coordBC_B(:, index) = harrisC(:, m);
    end

    nMatchCA = size(matchesCA, 2);
    coordCA_A = zeros(2, nMatchCA);
    coordCA_B = zeros(2, nMatchCA);

    for index=1:nMatchCA
        n = matchesCA(1, index);
        m = matchesCA(2, index);
        coordCA_A(:, index) = harrisC(:, n);
        coordCA_B(:, index) = harrisA(:, m);
    end

    %% Save!
    save([outputpath, num2str(hA), num2str(hB), num2str(hC), num2str(bins), 'coord'], ...
        'coordAB_A', 'coordAB_B', ...
        'coordBC_A', 'coordBC_B', ...
        'coordCA_A', 'coordCA_B');

    %% Ransac
    [coordAB_AOpt, coordAB_BOpt] = myRANSAC(coordAB_A, coordAB_B, 1e5, 20);
    [coordBC_AOpt, coordBC_BOpt] = myRANSAC(coordBC_A, coordBC_B, 1e5, 20);
    [coordCA_AOpt, coordCA_BOpt] = myRANSAC(coordCA_A, coordCA_B, 1e5, 20);

    %% Save!
    save([outputpath, num2str(hA), num2str(hB), num2str(hC), num2str(bins), 'ransaccoord'], ...
        'coordAB_AOpt', 'coordAB_BOpt', ...
        'coordBC_AOpt', 'coordBC_BOpt', ...
        'coordCA_AOpt', 'coordCA_BOpt');

    %% Visualise matches.
    if showImg
        figure;
        p1 = cornerPoints(coordAB_AOpt');
        p2 = cornerPoints(coordAB_BOpt');
        showMatchedFeatures(imgA, imgB, p1, p2);
        fig = gcf;
        fig.PaperPositionMode = 'auto';
        print([outputpath, num2str(hA), num2str(hB), num2str(hC), num2str(bins), 'AB'],'-dpng','-r0');

        figure;
        p1 = cornerPoints(coordBC_AOpt');
        p2 = cornerPoints(coordBC_BOpt');
        showMatchedFeatures(imgB, imgC, p1, p2);
        fig = gcf;
        fig.PaperPositionMode = 'auto';
        print([outputpath, num2str(hA), num2str(hB), num2str(hC), num2str(bins), 'BC'],'-dpng','-r0');

        figure;
        p1 = cornerPoints(coordCA_AOpt');
        p2 = cornerPoints(coordCA_BOpt');
        showMatchedFeatures(imgC, imgA, p1, p2);
        fig = gcf;
        fig.PaperPositionMode = 'auto';
        print([outputpath, num2str(hA), num2str(hB), num2str(hC), num2str(bins), 'CA'],'-dpng','-r0');
    end

    %% Estimate transformation matrices
    transformMatAB = estTransformMat(coordAB_AOpt, coordAB_BOpt);
    transformMatBC = estTransformMat(coordBC_AOpt, coordBC_BOpt);
    transformMatCA = estTransformMat(coordCA_AOpt, coordCA_BOpt);
    save([outputpath, num2str(hA), num2str(hB), num2str(hC), num2str(bins), 'trans'], 'transformMatAB', 'transformMatBC', 'transformMatCA');

    %% Warp Images!
    % [imgAB, refAB] = projection(imgA, transformMatAB);
    % [imgBC, refBC] = projection(imgB, transformMatBC);
    % [imgCA, refCA] = projection(imgC, transformMatCA);
    transformMatABObj = projective2d(transformMatAB');
    transformMatBCObj = projective2d(transformMatBC');
    transformMatCAObj = projective2d(transformMatCA');

    [imgAB, refAB] = imwarp(imgA, transformMatABObj);
    [imgBC, refBC] = imwarp(imgB, transformMatBCObj);
    [imgCA, refCA] = imwarp(imgC, transformMatCAObj);

    % Save pictures

    figure;
    imshowpair(imgB, imref2d(size(imgB)), imgAB, refAB);
    fig = gcf;
    fig.PaperPositionMode = 'auto';
    print([outputpath, num2str(hA), num2str(hB), num2str(hC), num2str(bins), 'ABpic'],'-dpng','-r0');

    figure;
    imshowpair(imgC, imref2d(size(imgC)), imgBC, refBC);
    fig = gcf;
    fig.PaperPositionMode = 'auto';
    print([outputpath, num2str(hA), num2str(hB), num2str(hC), num2str(bins), 'BCpic'],'-dpng','-r0');

    figure;
    imshowpair(imgA, imref2d(size(imgA)), imgCA, refCA);
    fig = gcf;
    fig.PaperPositionMode = 'auto';
    print([outputpath, num2str(hA), num2str(hB), num2str(hC), num2str(bins), 'CApic'],'-dpng','-r0');
end
