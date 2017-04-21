function [ transformMat ] = estTransformMat2( coordA, coordB )
%ESTTRANSFORMMAT Estimates transformation matrix from A to B
%   Uses matched co-ordinate pairs in coordA, coordB
%   coordA and coordB are 2xN matrices, N the same for both
%   Returns transformMat, a project2d containing 3x3 transformation matrix

% A = zeros(2*size(coordA, 2), 9);
A = zeros(size(coordA, 2), 9);

n = 0;
for i=1:size(coordA, 2)

    % Get points from patches
    xa = coordA(1, i);
    ya = coordA(2, i);
    xb = coordB(1, i);
    yb = coordB(2, i);

    A(i, :) = [-xb -yb -1 xb yb 1 ((xb*xa)-(xb*ya)) ((yb*xa)-(yb*ya)) (xa-ya)];
%     n = n + 1;
%     A(n, :) = [xb yb 1 0 0 0 -xa*xb -xa*yb -xa];
%     n = n + 1;
%     A(n, :) = [0 0 0 xb yb 1 -ya*xb -ya*yb -ya];

end

ATA = A'*A;
% [V,D] = eig(ATA);
[U,D,V] = svd(ATA);
D_vec = diag(D);

[minVal, minRow] = min(D_vec);
h_unscaled = V(minRow, :);

% [minVal, minCol] = min(D_vec);
% h_unscaled = V(:, minCol);

h_scaled = h_unscaled ./ h_unscaled(end);
transformMat = reshape(h_scaled, 3, 3)';
% transformMat = projective2d(h);

end

