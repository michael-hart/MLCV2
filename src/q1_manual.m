% Read and show two example images
imgA = imread('HG1.pgm');
imgB = imread('HG2.pgm');

% Define colour cellstrs for colour pairing
colours = cellstr(['red    '; 'blue   '; 'green  '; 'yellow '; 'magenta']);

% Create arrays for outputs
N = length(colours);
xA = zeros(1, N);
yA = zeros(1, N);
xB = zeros(1, N);
yB = zeros(1, N);

% Allow 5 points of interest per image
figure(1); imshow(imgA); hold on;
for i=1:N
    colour = deblank(char(colours(i)));
    disp(['Pick point of interest: ' colour]);
    [x, y] = ginput(1);
    xA(i) = x;
    yA(i) = y;
    % Create a crosshair where it was clicked
    scatter(x, y, 70, 'x', 'MarkerEdgeColor', colour, 'LineWidth', 2.0);
end

figure(2); imshow(imgB); hold on;
for i=1:N
    colour = deblank(char(colours(i)));
    disp(['Pick point of interest: ' colour]);
    [x, y] = ginput(1);
    xB(i) = x;
    yB(i) = y;
    % Create a crosshair where it was clicked
    scatter(x, y, 70, 'x', 'MarkerEdgeColor', colour, 'LineWidth', 2.0);
end

disp('Co-ordinates selected in image A were: ');
for i=1:N
    disp([num2str(i), ': x=', num2str(xA(i)), ', y=', num2str(yA(i))]);
end

disp('Co-ordinates selected in image B were: ');
for i=1:N
    disp([num2str(i), ': x=', num2str(xB(i)), ', y=', num2str(yB(i))]);
end
