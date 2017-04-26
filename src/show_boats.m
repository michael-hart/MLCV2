% Simple script to open and display each boat image for comparison
close all;

for i=1:6
    figure(i);
    imshow(imread(['img', num2str(i), '.pgm']));
end
