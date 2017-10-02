% Starter code prepared by James Hays for CSCI 1430 @ Brown and CS 4476 @ Georgia Tech
% This function returns detections on all of the images in a given path.
% You will want to use non-maximum suppression on your detections or your
% performance will be poor (the evaluation counts a duplicate detection as
% wrong). The non-maximum suppression is done on a per-image basis. The
% starter code includes a call to a provided non-max suppression function.
function [bboxes, confidences, image_ids] = .... 
    run_detector(test_scn_path, w, b, feature_params)
% 'test_scn_path' is a string. This directory contains images which may or
%    may not have faces in them. This function should work for the MIT+CMU
%    test set but also for any other images (e.g. class photos)
% 'w' and 'b' are the linear classifier parameters
% 'feature_params' is a struct, with fields
%   feature_params.template_size (default 36), the number of pixels
%      spanned by each train / test template and
%   feature_params.hog_cell_size (default 6), the number of pixels in each
%      HoG cell. template size should be evenly divisible by hog_cell_size.
%      Smaller HoG cell sizes tend to work better, but they make things
%      slower because the feature dimensionality increases and more
%      importantly the step size of the classifier decreases at test time.
%
% 'bboxes' is Nx4. N is the number of detections. bboxes(i,:) is
%   [x_min, y_min, x_max, y_max] for detection i. 
%   Remember 'y' is dimension 1 in Matlab!
% 'confidences' is Nx1. confidences(i) is the real valued confidence of
%   detection i.
% 'image_ids' is an Nx1 cell array. image_ids{i} is the image file name
%   for detection i. (not the full path, just 'albert.jpg')
%
% The placeholder version of this code will return random bounding boxes in
% each test image. It will even do non-maximum suppression on the random
% bounding boxes to give you an example of how to call the function.
%
% Your actual code should convert each test image to HoG feature space with
% a _single_ call to vl_hog for each scale. Then step over the HoG cells,
% taking groups of cells that are the same size as your learned template,
% and classifying them. If the classification is above some confidence,
% keep the detection and then pass all the detections for an image to
% non-maximum suppression. For your initial debugging, you can operate only
% at a single scale and you can skip calling non-maximum suppression. Err
% on the side of having a low confidence threshold (even less than zero) to
% achieve high enough recall.

test_scenes = dir(fullfile(test_scn_path,'*.jpg'));

%initialize these as empty and incrementally expand them.
bboxes = zeros(0,4);
confidences = zeros(0,1);
image_ids = cell(0,1);
feat_dim = 31*(feature_params.template_size/feature_params.hog_cell_size)^2;
cell_size = feature_params.hog_cell_size; % 3
temp_size = feature_params.template_size; % 36
num_feats = feature_params.template_size/feature_params.hog_cell_size; % 12
threshold = 0.75;

for n = 1:length(test_scenes)
    
    fprintf('Detecting faces in %s\n', test_scenes(n).name)
    img = imread(fullfile(test_scn_path, test_scenes(n).name));
    img = single(img)/255;
    if(size(img,3) > 1) % convert to grayscale if in color
        img = rgb2gray(img);
    end
    % create img for scale = 1;
    
    scales = [0.10, 0.25, 0.50, 0.75, 1, 1.25]; % scales to loop over
%    scales = [0.10, 0.25, 0.375, 0.50, 0.65 0.75, 0.875 1, 1.25]; % scales to loop over

    num_scales = length(scales);
    
    cur_bboxes = zeros(0,4);
    cur_confidences = zeros(0,1);
    cur_image_ids = {};
    ct = 0;
    [im_height, im_width] = size(img); % original image size
    
    for k = 1:num_scales % loop over the different scales
        scale = scales(k);
        img_scl = imresize(img,scale); % resize the image
        hog = vl_hog(img_scl,feature_params.hog_cell_size);
        % 444x601 image --> 74x100x31 in feature space
        [height, width, feat_len] = size(hog);
        
        for i = 1:height-num_feats % sliding window
            for j = 1:width-num_feats
                patch = hog(i:i+num_feats-1,j:j+num_feats-1,:); % patch is size 6x6x31
                patch_feat = reshape(patch,[feat_dim,1]); % patch_feat is size 1116x1
                score = w'*patch_feat+b; % w is a 1116x1 double
                if score > threshold % update cur_bboxes
                    ct = ct+1;
                    % Ok, how do I scale the coordinates?
                    % if the scale is 0.5, then the box is twice as big
                    bb_size = temp_size/scale;
                    % where do the coordinates map to?
                    cur_x_min = (cell_size*(j-1)+1)/scale; % this should chagne...
                    cur_y_min = (cell_size*(i-1)+1)/scale;
                    coords = [cur_x_min, cur_y_min, cur_x_min+bb_size-1, cur_y_min+bb_size-1];
                    cur_bboxes = cat(1,cur_bboxes,coords);
                    cur_confidences = [cur_confidences;score];
                    cur_image_ids{ct,1} = test_scenes(n).name;
                end
            end
        end
        
    end
    
    % takes cur_bboxes, a n x 4 array, n is the number of detections
    % cur_confidences is the an nx1 array of scores
    
    [is_maximum] = non_max_supr_bbox(cur_bboxes, cur_confidences, size(img));
    % is_maximum is a logical array indicating which are the maximums
    
    % get the non-suppressed boxes
    size(cur_confidences);
    size(cur_bboxes);
    size(cur_image_ids);
    size(is_maximum);
    
    cur_confidences = cur_confidences(is_maximum,:);
    cur_bboxes      = cur_bboxes(     is_maximum,:);
    cur_image_ids   = cur_image_ids(  is_maximum,:);
 
    % concatenates bboxes and cur_bboxes or whatever
    bboxes      = [bboxes;      cur_bboxes];
    confidences = [confidences; cur_confidences];
    image_ids   = [image_ids;   cur_image_ids];
end


end

