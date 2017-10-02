% Starter code prepared by James Hays for CSCI 1430 Computer Vision

%This function will sample SIFT descriptors from the training images,
%cluster them with kmeans, and then return the cluster centers.

function vocab = build_vocabulary(image_paths, vocab_size)
% The inputs are 'image_paths', a N x 1 cell array of image paths, and
% 'vocab_size' the size of the vocabulary.
% The output 'vocab' should be vocab_size x 128. Each row is a cluster
% centroid / visual word.

num_images = size(image_paths,1);
num_ims_sample = 200; % number of images to sample
num_feats_sample = 1000; % number of sift features to sample
sift_features = []; % sift_features should be veryverybigx128
inds = randi(num_images,1,num_ims_sample); % randomly choose 200 images to build a vocabulary

disp('Getting SIFT features to build vocabulary')
for i = inds
    im_dir = image_paths{i};
    train_im = single(imread(im_dir));
    [locations, SIFT_features] = vl_dsift(train_im,'fast'); % SIFT_features is a 128xN matrix, every column is a feature
    num_features = size(SIFT_features,2); % number of sift features generated
    sift_inds = randi(num_features,1,num_feats_sample); % randomly choose 1000 indices
    sift_feats = zeros(128,num_feats_sample); % empty placeholder
    % populate a 128x1000 matrix of features
    for k = 1:num_feats_sample
        sample_ind = sift_inds(k);
        sift_feats(:,k) = SIFT_features(:,sample_ind);
    end
    
    sift_features = cat(2, sift_features, sift_feats);
end


disp('Clustering...');
sift_features = single(sift_features); % 128 x 200,000 matrix
[centers, assignments] = vl_kmeans(sift_features, vocab_size);
% centers is a 128 x vocab_size matrix
vocab = centers'; % transpose to get vocab_size x 128 matrix










