% Local Feature Stencil Code
% Written by James Hays for CS 143 @ Brown / CS 4476/6476 @ Georgia Tech

% 'features1' and 'features2' are the n x feature dimensionality features
%   from the two images.
% If you want to include geometric verification in this stage, you can add
% the x and y locations of the features as additional inputs.
%
% 'matches' is a k x 2 matrix, where k is the number of matches. The first
%   column is an index in features1, the second column is an index
%   in features2. 
% 'Confidences' is a k x 1 matrix with a real valued confidence for every
%   match.
% 'matches' and 'confidences' can empty, e.g. 0x2 and 0x1.
function [matches, confidences] = match_features(features1, features2)
% Sort the matches so that the most confident onces are at the top of the
% list. You should probably not delete this, so that the evaluation
% functions can be run on the top matches easily.

matches = [];
confidences = [];
f1_len = size(features1,1);
f2_len = size(features2,1);
count = 0;

for i = 1:f1_len
    [f2m, nndr_m] = find_match(features1(i,:), features2);
    if nndr_m<0.85
        count = count+1;
        matches(count,1) = i;
        matches(count,2) = f2m;
        confidences(count) = 1-nndr_m;
    end
end

[confidences, ind] = sort(confidences, 'descend');
matches = matches(ind,:);
% matches = matches(1:100,:);
end


function [f2_match, nndr] = find_match(f1, f2_list)
    % finds a match given a feature from features1 and the list of feature2s
    dist_vector = [];
    for j = 1:size(f2_list,1)
        %distance = dot(f1, f2_list(j,:));
        distance = sum((f1-f2_list(j,:)).^2)^0.5;
        dist_vector(j) = distance;
    end
    %[dist_vector, sort_index] = sort(dist_vector, 'descend');
     [dist_vector, sort_index] = sort(dist_vector, 'ascend');
    f2_match = sort_index(1);
    %nndr = dist_vector(2)/dist_vector(1);
    nndr = dist_vector(1)/dist_vector(2);
end




