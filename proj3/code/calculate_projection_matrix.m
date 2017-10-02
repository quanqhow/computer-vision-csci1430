% Projection Matrix Stencil Code
% Written by Henry Hu, Grady Williams, and James Hays for CSCI 1430 @ Brown and CS 4495/6476 @ Georgia Tech

% Returns the projection matrix for a given set of corresponding 2D and
% 3D points. 

% 'Points_2D' is nx2 matrix of 2D coordinate of points on the image
% 'Points_3D' is nx3 matrix of 3D coordinate of points in the world

% 'M' is the 3x4 projection matrix


function M = calculate_projection_matrix(Points_2D, Points_3D)
% To solve for the projection matrix. You need to set up a system of
% equations using the corresponding 2D and 3D points:
%
%                                                     [M11       [ u1
%                                                      M12         v1
%                                                      M13         .
%                                                      M14         .
%[ X1 Y1 Z1 1 0  0  0  0 -u1*X1 -u1*Y1 -u1*Z1          M21         .
%  0  0  0  0 X1 Y1 Z1 1 -v1*X1 -v1*Y1 -v1*Z1          M22         .
%  .  .  .  . .  .  .  .    .     .      .          *  M23   =     .
%  Xn Yn Zn 1 0  0  0  0 -un*Xn -un*Yn -un*Zn          M24         .
%  0  0  0  0 Xn Yn Zn 1 -vn*Xn -vn*Yn -vn*Zn ]        M31         .
%                                                      M32         un
%                                                      M33         vn ]
%
% Then you can solve this using least squares with the '\' operator or SVD.
% Notice you obtain 2 equations for each corresponding 2D and 3D point
% pair. To solve this, you need at least 6 point pairs.


num_points = length(Points_2D);

A = zeros(2*num_points, 11);
b = zeros(2*num_points, 1);
row_ct = 1;

for i = 1:num_points
    X = Points_3D(i,1);
    Y = Points_3D(i,2);
    Z = Points_3D(i,3);
    u = Points_2D(i,1);
    v = Points_2D(i,2);
    row1 = [X Y Z 1 0 0 0 0 -u*X -u*Y -u*Z];
    row2 = [0 0 0 0 X Y Z 1 -v*X -v*Y -v*Z];
    A(row_ct,:) = row1;
    b(row_ct) = u;
    row_ct = row_ct+1;
    A(row_ct,:) = row2;
    b(row_ct) = v;
    row_ct = row_ct+1;
end

M_vec = A\b; 
mA = M_vec(1:4)';
mB = M_vec(5:8)';
mC = M_vec(9:11);
mC(4) = 1;

M = zeros(3, 4);
M(1,:) = mA;
M(2,:) = mB;
M(3,:) = mC;
end

