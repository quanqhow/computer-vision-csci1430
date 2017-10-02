% Starter code prepared by James Hays for CSCI 1430 Computer Vision

%This function will predict the category for every test image by finding
%the training image with most similar features. Instead of 1 nearest
%neighbor, you can vote based on k nearest neighbors which will increase
%performance (although you need to pick a reasonable value for k).

function predicted_categories = nearest_neighbor_classify(train_image_feats, train_labels, test_image_feats)
% image_feats is an N x d matrix, where d is the dimensionality of the
%  feature representation.
% train_labels is an N x 1 cell array, where each entry is a string
%  indicating the ground truth category for each training image.
% test_image_feats is an M x d matrix, where d is the dimensionality of the
%  feature representation. You can assume M = N unless you've modified the
%  starter code.
% predicted_categories is an M x 1 cell array, where each entry is a string
%  indicating the predicted category for each test image.

num_images = size(test_image_feats,1); % number of test images 
train_size = size(train_image_feats,1); % number of training images
predicted_categories = cell(num_images,1); % initialize predicted categories matrix

for i = 1:num_images
    predicted_categories{i,1} = classify_im(test_image_feats(i,:), train_image_feats, train_labels);
    % populate predicted categories
end
    
end

function class_str = classify_im(im_feat, train_image_feats, train_labels)
% Takes in an image feature representation, training image features and
% training labels and returns a class string

train_data_size = size(train_image_feats,1);
distances = ones(train_data_size,1);

for i = 1:train_data_size    
    distances(i) = sqrt(vl_alldist2(im_feat',train_image_feats(i,:)'));
end

[distances, sort_index] = sort(distances,'ascend');
ind = sort_index(1);
class_str = train_labels{ind};

end









