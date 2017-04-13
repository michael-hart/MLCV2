function [ points ] = harris( img, thresh )
%HARRIS Returns 2xN matrix of interest points
%   Smoothing matrix is hard coded
%   2xN matrix is x,y co-ordinates of interest points, denoted points
%   img is the input image
%   thresh is the threshold; consider around 1e7

    % With thanks to
    % http://web.engr.illinois.edu/~slazebni/spring16/harris.m
    % for clues on implementation of this algorithm

    % Blurring function determined by coursework
    blur = [0.03 0.105 0.222 0.286 0.222 0.105 0.03];

    % Use convolution matrix given
    cnv = double([-1 0 1]);
    dx = cnv;
    dy = cnv';

    % Differentiate wrt x, y
    Ix = conv2(double(img), dx, 'same');
    Iy = conv2(double(img), dy, 'same');
    
    % Differentiate Ix, Iy wrt x, y
    Ixx = conv2(Ix.^2, blur, 'same'); % Smoothed squared image derivatives
    Iyy = conv2(Iy.^2, blur, 'same');
    Ixy = conv2(Ix.*Iy, blur, 'same');

    % Calculate Harris corner measure, with epsilon in denominator to 
    % prevent divide-by-zero
    harris = (Ixx.*Iyy - Ixy.^2)./(Ixx + Iyy + eps);
    
    % Take Hessian determinant
    hess = (Ixx .* Iyy) - (Ixy .* Ixy);

    % Compare to a threshold
    N = sum(sum(hess > thresh));
    points = zeros(2, N);

    n = 1;
    for row=1:size(harris, 1)
        for col=1:size(harris, 2)
            if harris(row, col) > thresh
                points(1, n) = col;
                points(2, n) = row;
                n = n + 1;
            end
        end
    end
    
end

