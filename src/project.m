function [ proj, err ] = project( img, h )
%PROJECT Summary of this function goes here
%   Detailed explanation goes here

% Going to take an image and project it onto the same-sized space
% whilst measuring the error during the process

n = 0;
err = 0;
sum_err = 0;

proj = uint8(zeros(size(img)));
for i=1:size(img, 1)
    for j=1:size(img, 2)
        x = j;
        y = i;
        homog = h'*[x; y; 1];
        out = homog ./ homog(3);
        x2 = round(out(1));
        y2 = round(out(2));
        
        % Check projected point is within bounds
        if x2 <= size(proj, 2) && y2 <= size(proj, 1) && x2 > 0 && y2 > 0
            % Set project point value
            proj(y2, x2) = img(y, x);
            % Update error
            sum_err = sum_err + sqrt((y2 - y)^2 + abs(x2 - x)^2);
            n = n + 1;
        end
    end
end

% Calculate average error as average distance from projected to actual
err = sum_err / n;

end

