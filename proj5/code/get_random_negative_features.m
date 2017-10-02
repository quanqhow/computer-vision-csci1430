% Starter code prepared by James Hays for CSCI 1430 @ Brown and CS 4476 @ Georgia Tech
% This function should return negative training examples (non-faces) from
% any images in 'non_face_scn_path'. Images should be converted to
% grayscale because the positive training data is only available in
% grayscale. For best performance, you should sample random negative
% examples at multiple scales.

function features_neg = get_random_negative_features(non_face_scn_path, feature_params, num_samples)
% 'non_face_scn_path' is a string. This directory contains many images
%   which have no faces in them.
% 'feature_params' is a struct, with fields
%   feature_params.template_size (default 36), the number of pixels
%      spanned by each train / test template and
%   feature_params.hog_cell_size (default 6), the number of pixels in each
%      HoG cell. template size should be evenly divisible by hog_cell_size.
%      Smaller HoG cell sizes tend to work better, but they make things
%      slower because the feature dimensionality increases and more
%      importantly the step size of the classifier decreases at test time.
% 'num_samples' is the number of random negatives to be mined, it's not
%   important for the function to find exactly 'num_samples' non-face
%   features, e.g. you might try to sample some number from each image, but
%   some images might be too small to find enough.

% 'features_neg' is N by D matrix where N is the number of non-faces and D
% is the template dimensionality, which would be
%   (feature_params.template_size / feature_params.hog_cell_size)^2 * 31
% if you're using the default vl_hog parameters


image_files = dir( fullfile( non_face_scn_path, '*.jpg' ));
num_images = length(image_files);
feat_dim = 31*(feature_params.template_size/feature_params.hog_cell_size)^2;
features_neg = zeros(num_samples,feat_dim);
feats_per_im = floor(num_samples/num_images);
ind = 0;
t_size = feature_params.template_size;

for i = 1:num_images
    im_dir = fullfile(image_files(i).folder,image_files(i).name);
    image = single(rgb2gray(imread(im_dir)));
    [rows,cols] = size(image);
    for j = 1:feats_per_im
        ind = ind+1;
        row_start = randi([1,rows-t_size]);
        col_start = randi([1,cols-t_size]);
        cropped_im = image(row_start:row_start+t_size-1,col_start:col_start+t_size-1);
        hog = vl_hog(cropped_im,feature_params.hog_cell_size);
        feat = reshape(hog,[1,feat_dim]);
        features_neg(ind,:) = feat;
    end
end


end




