% Starter code prepared by James Hays for CSCI 1430 Computer Vision

%This feature is inspired by the simple tiny images used as features in 
%  80 million tiny images: a large dataset for non-parametric object and
%  scene recognition. A. Torralba, R. Fergus, W. T. Freeman. IEEE
%  Transactions on Pattern Analysis and Machine Intelligence, vol.30(11),
%  pp. 1958-1970, 2008. http://groups.csail.mit.edu/vision/TinyImages/

function image_feats = get_tiny_images(image_paths)
% image_paths is an N x 1 cell array of strings where each string is an
%  image path on the file system.
% image_feats is an N x d matrix of resized and then vectorized tiny
%  images. E.g. if the images are resized to 16x16, d would equal 256.
%
% To build a tiny image feature, simply resize the original image to a very
% small square resolution, e.g. 16x16. You can either resize the images to
% square while ignoring their aspect ratio or you can crop the center
% square portion out of each image. Making the tiny images zero mean and
% unit length (normalizing them) will increase performance modestly.
%
% suggested functions: imread, imresize

num_images = size(image_paths,1);
sml_im_size = 16;
image_feats = zeros(num_images,sml_im_size^2);

for i = 1:num_images
    im_dir = image_paths{i};
    big_im = imread(im_dir);
    feature_vector = vectorize_im(big_im,sml_im_size);
    image_feats(i,:) = feature_vector;
end


end

function feat_vector = vectorize_im(image, size)
small_im = imresize(image,[size size]);
feat_vector = zeros(1,size*size);
ind = 1;
for i = 1:size
    for j = 1:size
        feat_vector(1,ind) = small_im(i,j);
        ind = ind+1;
    end
end

end



