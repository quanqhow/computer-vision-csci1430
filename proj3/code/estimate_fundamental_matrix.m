% Fundamental Matrix Stencil Code
% Written by Henry Hu for CSCI 1430 @ Brown and CS 4495/6476 @ Georgia Tech

% Returns the camera center matrix for a given projection matrix

% 'Points_a' is nx2 matrix of 2D coordinate of points on Image A
% 'Points_b' is nx2 matrix of 2D coordinate of points on Image B
% 'F_matrix' is 3x3 fundamental matrix

% Try to implement this function as efficiently as possible. It will be
% called repeatly for part III of the project

function [ F_matrix ] = estimate_fundamental_matrix(Points_a,Points_b)

num_points = min(length(Points_a), length(Points_b));
A = zeros(num_points,9);
% A = [];

for i = 1:num_points
    u = Points_a(i,1);
    v = Points_a(i,2);
    up = Points_b(i,1);
    vp = Points_b(i,2);
    row = [u*up v*up up u*vp v*vp vp u v 1];
    A(i,:) = row;
end
% A is a 20x9 matrix

[U S V] = svd(A); % U is a 20x20 matrix, S is a 20x9 matrix, V is a 9x9 matrix
f = V(:, end); % last column of V
F = reshape(f, [3 3])';

[U S V] = svd(F);
S(3,3) = 0;
F_matrix = U*S*V';

        
end

