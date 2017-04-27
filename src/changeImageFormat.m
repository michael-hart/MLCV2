% Create cellstr of all image names
names = cellstr(['FD1'; 'FD2'; 'FD3'; 'HG1'; 'HG2'; 'HG3']);

for i=1:length(names)
    
    % Read image in - requires res/kitchen to be on path already
    img = imread([char(names(i)) '.JPG']);

    % Scale down to 862x1148 from 3448x4592 using resize with factor 1/4
    img = imresize(img, 0.25);

    % Convert to grayscale
    img = rgb2gray(img);

    % Save it with the original filename but a different format
    imwrite(img, ['res/kitchen/' char(names(i)) '.pgm']);
end
