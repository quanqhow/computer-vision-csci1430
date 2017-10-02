% Starter code prepared by James Hays for CSCI 1430 Computer Vision

%This feature representation is described in the handout, lecture
%materials, and Szeliski chapter 14.

function image_feats = get_bags_of_sifts(image_paths)
% image_paths is an N x 1 cell array of strings where each string is an
% image path on the file system.
%
% This function assumes that 'vocab.mat' exists and contains an N x 128
% matrix 'vocab' where each row is a kmeans centroid or visual word. This
% matrix is saved to disk rather than passed in a parameter to avoid
% recomputing the vocabulary every run.
%
% image_feats is an N x d matrix, where d is the dimensionality of the
% feature representation. In this case, d will equal the number of clusters
% or equivalently the number of entries in each image's histogram
% ('vocab_size') below.
%
% You will want to construct SIFT features here in the same way you
% did in build_vocabulary.m (except for possibly changing the sampling
% rate) and then assign each local feature to its nearest cluster center
% and build a histogram indicating how many times each cluster was used.
% Don't forget to normalize the histogram, or else a larger image with more
% SIFT features will look very different from a smaller version of the same
% image.

load('vocab.mat'); % vocab is a n x 128 matrix, n is the vocab size, 200x128
vocab = single(vocab);
vocab_size = size(vocab,1); % default is 200
num_test_images = size(image_paths,1); % number of test images
image_feats = zeros(num_test_images,vocab_size); % num_images x 200, this is the histogram matrix
num_to_sample = 500; % number of features to sample, reducing this number dramatically improves runtime

for i = 1:num_test_images
    histo = zeros(1,vocab_size);
    im_dir = image_paths{i};
    image = single(imread(im_dir));
    
    [locations, sift_features] = vl_dsift(image, 'fast', 'step', 15);
    % 128 x n image features where n is the number of features
    
    num_feats = size(sift_features,2); % number of sift features generated
    sift_feats = zeros(128,num_to_sample); % placeholder
    sift_inds = randi(num_feats,1,num_to_sample);
    for k = 1:num_to_sample
        sample_ind = sift_inds(k);
        sift_feats(:,k) = sift_features(:,sample_ind);
        % sift_feats is 128 x n matrix
    end
    
    sift_feats = single(sift_feats'); % sift_feats is now a n x 128 matrix
    num_feats = size(sift_feats,1); % number of features
    
    for j = 1:num_feats
        feat_in = sift_feats(j,:); % examine this feature for a given image
        word_indx = find_nearest_center(feat_in,vocab); % get the index of the closest center
        histo(word_indx) = histo(word_indx)+1; % add one to the count
    end
    
    
    image_feats(i,:) = histo;
end

end

function word_ind = find_nearest_center(input_feat, vocab_mat)
    % input_feat is a 1 x 128 feature
    % vocab_mat is a 200 x 128 'dictionary'
    % return the index of vocab_mat that matches input_feat best
    vocab_size = size(vocab_mat,1); % 200
    distances = ones(vocab_size,1); % 200x1 matrix 
    for i = 1:vocab_size
        distances(i) = sqrt(vl_alldist2(input_feat',vocab_mat(i,:)'));
    end
    
    [distances, sort_index] = sort(distances,'ascend');
    word_ind = sort_index(1);
end





