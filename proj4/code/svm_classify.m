% Starter code prepared by James Hays for CSCI 1430 Computer Vision

%This function will train a linear SVM for every category (i.e. one vs all)
%and then use the learned linear classifiers to predict the category of
%every test image. Every test feature will be evaluated with all 15 SVMs
%and the most confident SVM will "win". Confidence, or distance from the
%margin, is W*X + B where '*' is the inner product or dot product and W and
%B are the learned hyperplane parameters.

function predicted_categories = svm_classify(train_image_feats, train_labels, test_image_feats, categories)
% image_feats is an N x d matrix, where d is the dimensionality of the
%  feature representation.
%
% train_labels is an N x 1 cell array, where each entry is a string
%  indicating the ground truth category for each training image.
%
% test_image_feats is an M x d matrix, where d is the dimensionality of the
%  feature representation. You can assume M = N unless you've modified the
%  starter code.
%
% predicted_categories is an M x 1 cell array, where each entry is a string
%  indicating the predicted category for each test image.

num_categories = length(categories); 
num_test_images = size(test_image_feats,1);
lambda = 0.001;
feat_size = size(train_image_feats,2);
W_mat = zeros(feat_size,num_categories); % initialize a 200x15 matrix
B_mat = zeros(num_categories,1); % intialize a 15x1 column vector
predicted_categories = cell(num_test_images,1); % intiailize predicted categories

for i = 1:num_categories
    cat_str = categories{i};
    labels = strcmp(cat_str,train_labels);
    labels = cast(labels,'double');
    for j = 1:length(labels)
        if labels(j) == 0
            labels(j) = -1;
        end
    end
    % for every category create a label vector
    % I should now have labels, a 1500x1 vector, might need to transpose
    % I am trying to call [W B] = vl_svmtrain(features, labels, lambda)
    % features should be a 200xN matrix, just transpose train_image_feats
    
    [W B] = vl_svmtrain(train_image_feats',labels',lambda);
    % I should get B as scalar and W as a 200x1 weighting vector
    % get W and B and store it in W_mat and B_mat, respectively
    W_mat(:,i) = W;
    B_mat(i) = B;
end


for k = 1:num_test_images
    distances = zeros(1,num_categories);
    for w = 1:num_categories
        distances(w) = W_mat(:,w)'*test_image_feats(k,:)' + B_mat(w);
    end
    [distances,sort_index] = sort(distances,'descend');
    ind = sort_index(1);
    predicted_categories{k} = categories{ind};
end



% W_mat 200x15
% B_mat is 15x1
% W_mat(:,i) corresponds to the W for categories{i}

%{
The Algorithm

- Create a SVM for every category
    - Create 1 vs all label vectors for every category
    - Create a 1500x1 label vector of 1 or -1
    - Ok I can use strcmp('Kitchen', train_labels)
    - cycle through all the values of categories
    - Need to place -1s instead of zeros and cast it from a logical to a
    single or double or whatever 
    - call vl_svmtrain for every one of those label vectors
    - Now you should have 15 W's and 15 b's
    - Okay, how should I indicate which W's correspond to which index...
    - Well first I want to store the Ws
    - Store the labels in a separate vector, each column index corresopnds
    to the same label in the column of the W matrix
- For every test image
- For every W and B
    - compute W'*features(:,i)+b
    - take the highest value
    - The W and B that correspond to the highest value are the most
    confident match
    - save that label into predicted_categories for that image

- [W B] = vl_svmtrain(features, labels, lambda)

labels is a double vector with N, -1 or 1 entries
features is a D x N matrix
- D are the feature dimensions (200 for the histogram, 256 for the tiny
image) 1 feature per image
- N is the number of images
- W is the weighting vector
- B is the offset
- W'*features(:,i)+b has the same sign of labels(i)

features(:,i) is a 200x1 feature vector representing an image
W' should then be a 1x200 weighting vector
W is a 200x1 weighting vector
b is a scalar offset
labels(i) is a scalar

%}



%{
Useful functions:
 matching_indices = strcmp(string, cell_array_of_strings)
 
  This can tell you which indices in train_labels match a particular
  category. This is useful for creating the binary labels for each SVM
  training task.

[W B] = vl_svmtrain(features, labels, LAMBDA)
  http://www.vlfeat.org/matlab/vl_svmtrain.html

  This function trains linear svms based on training examples, binary
  labels (-1 or 1), and LAMBDA which regularizes the linear classifier
  by encouraging W to be of small magnitude. LAMBDA is a very important
  parameter! You might need to experiment with a wide range of values for
  LAMBDA, e.g. 0.00001, 0.0001, 0.001, 0.01, 0.1, 1, 10.

  Matlab has a built in SVM, see 'help svmtrain', which is more general,
  but it obfuscates the learned SVM parameters in the case of the linear
  model. This makes it hard to compute "confidences" which are needed for
  one-vs-all classification.

%}

%unique() is used to get the category list from the observed training
%category list. 'categories' will not be in the same order as in proj4.m,
%because unique() sorts them. This shouldn't really matter, though.
% categories = unique(train_labels); 
% num_categories = length(categories);




