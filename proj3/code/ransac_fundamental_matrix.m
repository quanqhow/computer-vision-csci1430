% Written by Henry Hu for CSCI 1430 @ Brown and CS 4495/6476 @ Georgia Tech

% Find the best fundamental matrix using RANSAC on potentially matching
% points

% 'matches_a' and 'matches_b' are the Nx2 coordinates of the possibly
% matching points from pic_a and pic_b. Each row is a correspondence (e.g.
% row 42 of matches_a is a point that corresponds to row 42 of matches_b.

% 'Best_Fmatrix' is the 3x3 fundamental matrix
% 'inliers_a' and 'inliers_b' are the Mx2 corresponding points (some subset
% of 'matches_a' and 'matches_b') that are inliers with respect to
% Best_Fmatrix.

% For this section, use RANSAC to find the best fundamental matrix by
% randomly sample interest points. You would reuse
% estimate_fundamental_matrix() from part 2 of this assignment.

% If you are trying to produce an uncluttered visualization of epipolar
% lines, you may want to return no more than 30 points for either left or
% right images.

function [ Best_Fmatrix, inliers_a, inliers_b] = ransac_fundamental_matrix(matches_a, matches_b)

num_matches = min(size(matches_a,1), size(matches_b,1));
Best_Fmatrix = zeros(3,3);
inliers = 0;
inliers_a = [];
inliers_b = [];

for i = 1:5000 % RANSAC 2000 times
    sam_num = randi([10 15],1,1); % randomly choose a number between 10 and 15 to sample
    % populate pts_a and pts_b
    pts_a = zeros(sam_num,2); % sam_num x 2 array
    pts_b = zeros(sam_num,2); % sam_num x 2 array
    for j = 1:sam_num
        match_ind = randi([1 num_matches], 1, 1);
        pts_a(j,:) = matches_a(match_ind,:);
        pts_b(j,:) = matches_b(match_ind,:);
    end
    
    % estimate the fundamental matrix with the random matches
    F_mat = estimate_fundamental_matrix(pts_a,pts_b);
    
    inliers_ct_temp = 0;
    outliers_temp = 0;
    threshold = 0.000001;
    x = [];
    x_p = [];
    inliers_a_temp = [];
    inliers_b_temp = [];
    
    for k = 1:num_matches
        x(1,1) = matches_a(k,1);
        x(2,1) = matches_a(k,2);
        x(3,1) = 1;
        x_p(1,1) = matches_b(k,1);
        x_p(2,1) = matches_b(k,2);
        x_p(3,1) = 1;
        dist = x_p'*F_mat*x;
        if dist<threshold
            inliers_ct_temp = inliers_ct_temp+1;
            inliers_a_temp(inliers_ct_temp,1) = x(1,1);
            inliers_a_temp(inliers_ct_temp,2) = x(2,1);
            inliers_b_temp(inliers_ct_temp,1) = x_p(1,1);
            inliers_b_temp(inliers_ct_temp,2) = x_p(2,1);
        elseif dist>threshold
            outliers_temp = outliers_temp+1;
        end
    end
    
    if inliers_ct_temp > inliers
        inliers = inliers_ct_temp;
        Best_Fmatrix = F_mat;
        inliers_a = inliers_a_temp;
        inliers_b = inliers_b_temp;
    end  
end

inliers

end

