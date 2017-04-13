% Simple script to open and display each boat image for comparison

for i=1:5
    figure(i);
    imshow(imread(['img', num2str(i), '.pgm']));
end
