% Camera Center Stencil Code
% Written by Henry Hu, Grady Williams, and James Hays for CSCI 1430 @ Brown and CS 4495/6476 @ Georgia Tech

% Returns the camera center matrix for a given projection matrix

% 'M' is the 3x4 projection matrix
% 'Center' is the 1x3 matrix of camera center location in world coordinates

function [ Center ] = compute_camera_center( M )

%%%%%%%%%%%%%%%%
% Your code here
%%%%%%%%%%%%%%%%

% M = (Q|m4);
Q = M(1:3, 1:3);
m4 = M(1:3,4);
Center = -inv(Q)*m4;


% Center = [1 1 1]; %replace this with the correct code
%In the visualization you will see that this camera location is clearly
%incorrect, placing it in the center of the room where it would not see all
%of the points.

end

