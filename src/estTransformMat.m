function [ transformMat ] = estTransformMat2( coordA, coordB )
%ESTTRANSFORMMAT Estimates transformation matrix from A to B
%   Uses matched co-ordinate pairs in coordA, coordB
%   coordA and coordB are 2xN matrices, N the same for both
%   Returns transformMat, a 3x3 transformation matrix

A = zeros(2*size(coordA, 2), 9);

n = 0;
for i=1:size(coordA, 2)
    % Get points from patches
    xa = coordA(1, i);
    ya = coordA(2, i);
    xb = coordB(1, i);
    yb = coordB(2, i);

    n = n + 1;
    A(n, :) = [xa ya 1 0 0 0 -xa*xb -ya*xb -xb];
    n = n + 1;
    A(n, :) = [0 0 0 xa ya 1 -xa*yb -ya*yb -yb];

end

ATA = A'*A;
% Perform SVD decomposition
[U,D,V] = svd(ATA);

% Iterate over possible h vectors and select the least error for list of
% points
err = zeros(1, size(V, 2));
for i=1:size(V, 2)
    h = reshape(V(:, i) ./ V(9, i), 3, 3)';
    for j=1:size(coordA, 2)
        xa = coordA(1, i);
        ya = coordA(2, i);
        xb = coordB(1, i);
        yb = coordB(2, i);
        err(i) = err(i) + sum([xa; ya; 1] - (h * [xb; yb; 1]));
        disp(['Error for ' num2str(i) ' is ' num2str(err(i))]);
    end
end

[minVal, minCol] = min(abs(err));
h_unscaled = V(:, minCol);

h_scaled = h_unscaled ./ h_unscaled(end);
transformMat = reshape(h_scaled, 3, 3)';

end

