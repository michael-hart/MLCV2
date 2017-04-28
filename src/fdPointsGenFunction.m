function [] = fdPointsGenFunction(hA, hB, hC, bins)
    if ismac
        addpath('../res/kitchen');
        addpath('../res');
        outputpath = ('../res/');
    else
        addpath('res/kitchen')
        addpath('res');
        outputpath = ('res/');
    end

    imgA = imread('FD1.pgm');
    imgB = imread('FD2.pgm');
    imgC = imread('FD3.pgm');

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
    save([outputpath, 'fd', num2str(hA), '_', num2str(hB), '_', num2str(hC), '_', num2str(bins), 'coord'], ...
        'coordAB_A', 'coordAB_B', ...
        'coordBC_A', 'coordBC_B', ...
        'coordCA_A', 'coordCA_B');

  end
