% Starter code prepared by James Hays for CSCI 1430 @ Brown and CS 4476 @ Georgia Tech
% This function should return all positive training examples (faces) from
% 36x36 images in 'train_path_pos'. Each face should be converted into a
% HoG template according to 'feature_params'. For improved performance, try
% mirroring or warping the positive training examples to augment your
% training data.

function features_pos = get_positive_features(train_path_pos, feature_params)
% 'train_path_pos' is a string. This directory contains 36x36 images of
%   faces
% 'feature_params' is a struct, with fields
%   feature_params.template_size (default 36), the number of pixels
%      spanned by each train / test template and
%   feature_params.hog_cell_size (default 6), the number of pixels in each
%      HoG cell. template size should be evenly divisible by hog_cell_size.
%      Smaller HoG cell sizes tend to work better, but they make things
%      slower because the feature dimensionality increases and more
%      importantly the step size of the classifier decreases at test time.
%      (although you don't have to make the detector step size equal a
%      single HoG cell).


% 'features_pos' is N by D matrix where N is the number of faces and D
% is the template dimensionality, which would be
%   (feature_params.template_size / feature_params.hog_cell_size)^2 * 31
% (36/6)^2 = 36 ... 36*31 = 1,116

image_files = dir(fullfile(train_path_pos,'*.jpg'));
% Caltech Faces stored as .jpg
% 6713x1 struct array with fields: name, folder, date, bytes, isdir,
% datenum
% image_files(2).name
num_images = length(image_files);

feat_dim = 31*(feature_params.template_size/feature_params.hog_cell_size)^2;
features_pos = zeros(num_images,feat_dim);

for i = 1:num_images    
    im_dir = fullfile(image_files(i).folder,image_files(i).name);
    image = single(imread(im_dir));
    hog = vl_hog(image,feature_params.hog_cell_size);
    % 6x6x31 tensor, concatenate into a 1x1116 feature vector
    feat = reshape(hog,[1,feat_dim]);
    features_pos(i,:) = feat;
end

end