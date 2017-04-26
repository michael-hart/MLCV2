disp('matchy Start.');
for outside = 1:5
    % Acquire image A. Perform Harris. Obtain features.
    imgA = imread(strcat('img', num2str(outside), '.pgm'));
    harrisA = harris(imgA, 2500);
    describeA = describe2(imgA, harrisA);

    for inside = outside+1:6
        % Acquire image B. Perform Harris. Obtain features.
        disp(['Outside value: ', num2str(outside), ' Inside value: ', num2str(inside)]);
        
        imgB = imread(strcat('img', num2str(outside), '.pgm'));
        harrisB = harris(imgB, 2500);
        describeB = describe2(imgB, harrisB);
        
        disp('Matching.');
        % Obtain NN matches.
        [matches] = matchPatches(describeA, describeB);
        disp('Matched.');

        % Based on matched patches, build two matrices of co-ordinates
        nMatch = size(matches, 2);
        coordA = zeros(2, nMatch);
        coordB = zeros(2, nMatch);
    
        % Obtain list of corresponding points.
        for i=1:nMatch
            n = matches(1, i);
            m = matches(2, i);
            coordA(:, i) = harrisA(:, n);
            coordB(:, i) = harrisB(:, m);
        end
        
        disp('RANSACing.');
        [coordOptA, coordOptB] = myRANSAC(coordA, coordB, 1e5, 20);
        disp('RANSACed.');

        
        % Save files.
        if ismac
            savefilename = strcat('../res/matches_', num2str(outside), '_', num2str(inside),'.mat');
        else
            savefilename = strcat('res/matches_', num2str(outside), '_', num2str(inside),'.mat');
        end
        
        save(savefilename, 'coordA', 'coordB', 'coordOptA', 'coordOptB');
    end
end

disp('matchy End.');