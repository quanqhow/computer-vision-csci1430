% Before trying to construct hybrid images, it is suggested that you
% implement my_imfilter.m and then debug it using proj1_test_filtering.m

% Debugging tip: You can split your MATLAB code into cells using "%%"
% comments. The cell containing the cursor has a light yellow background,
% and you can press Ctrl+Enter to run just the code in that cell. This is
% useful when projects get more complex and slow to rerun from scratch

close all; % closes all figures

%% Setup
% read images and convert to floating point format
% image1 = im2single(imread('../data/dog.bmp'));
% image2 = im2single(imread('../data/cat.bmp'));

% Several additional test cases are provided for you, but feel free to make
% your own (you'll need to align the images in a photo editor such as
% Photoshop). The hybrid images will differ depending on which image you
% assign as image1 (which will provide the low frequencies) and which image
% you asign as image2 (which will provide the high frequencies)

%% Filtering and Hybrid Image construction
cutoff_frequency1 = 5;
cutoff_frequency2 = 5;
cutoff_frequency3 = 4;
cutoff_frequency4 = 7;
cutoff_frequency5 = 5;
cutoff_frequency6 = 2;
% This is the standard deviation, in pixels, of the 
% Gaussian blur that will remove the high frequencies from one image and 
% remove the low frequencies from another image (by subtracting a blurred
% version from the original version). You will want to tune this for every
% image pair to get the best results.
filter1 = fspecial('Gaussian', cutoff_frequency1*4+1, cutoff_frequency1);
filter2 = fspecial('Gaussian', cutoff_frequency2*4+1, cutoff_frequency2);
filter3 = fspecial('Gaussian', cutoff_frequency3*4+1, cutoff_frequency3);
filter4 = fspecial('Gaussian', cutoff_frequency4*4+1, cutoff_frequency4);
filter5 = fspecial('Gaussian', cutoff_frequency5*4+1, cutoff_frequency5);
filter6 = fspecial('Gaussian', cutoff_frequency6*4+1, cutoff_frequency6);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE BELOW. Use my_imfilter to create 'low_frequencies' and
% 'high_frequencies' and then combine them to create 'hybrid_image'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Remove the high frequencies from image1 by blurring it. The amount of
% blur that works best will vary with different image pairs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
low_source1 = im2single(imread('../data/bicycle.bmp'));
low_filtered1 = my_imfilter(low_source1, filter1);
low_frequencies1 = low_filtered1;

low_source2 = im2single(imread('../data/dog.bmp'));
low_filtered2 = my_imfilter(low_source2, filter3);
low_frequencies2 = low_filtered2;

low_source3 = im2single(imread('../data/bird.bmp'));
low_filtered3 = my_imfilter(low_source3, filter5);
low_frequencies3 = low_filtered3;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Remove the low frequencies from image2. The easiest way to do this is to
% subtract a blurred version of image2 from the original version of image2.
% This will give you an image centered at zero with negative values.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

high_source1 = im2single(imread('../data/bicycle.bmp'));
high_filtered1 = my_imfilter(high_source1, filter2);
high_frequencies1 = high_source1-high_filtered1;

high_source2 = im2single(imread('../data/cat.bmp'));
high_filtered2 = my_imfilter(high_source2, filter4);
high_frequencies2 = high_source2-high_filtered2;

high_source3 = im2single(imread('../data/plane.bmp'));
high_filtered3 = my_imfilter(high_source3, filter6);
high_frequencies3 = high_source3-high_filtered3;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Combine the high frequencies and low frequencies
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hybrid_image1 = high_frequencies1+low_frequencies1;
hybrid_image2 = high_frequencies2+low_frequencies2;
hybrid_image3 = high_frequencies3+low_frequencies3;



%% Visualize and save outputs
figure(1); imshow(low_frequencies1)
figure(2); imshow(high_frequencies1 + 0.5);
vis = vis_hybrid_image(hybrid_image1);
figure(3); imshow(vis);
imwrite(low_frequencies1, 'low_frequencies1.jpg', 'quality', 95);
imwrite(high_frequencies1 + 0.5, 'high_frequencies1.jpg', 'quality', 95);
imwrite(hybrid_image1, 'hybrid_image1.jpg', 'quality', 95);
imwrite(vis, 'hybrid_image_scales1.jpg', 'quality', 95);

figure(3); imshow(low_frequencies2)
figure(4); imshow(high_frequencies2 + 0.5);
vis = vis_hybrid_image(hybrid_image2);
figure(5); imshow(vis);
imwrite(low_frequencies2, 'low_frequencies2.jpg', 'quality', 95);
imwrite(high_frequencies2 + 0.5, 'high_frequencies2.jpg', 'quality', 95);
imwrite(hybrid_image2, 'hybrid_image2.jpg', 'quality', 95);
imwrite(vis, 'hybrid_image_scales2.jpg', 'quality', 95);

figure(6); imshow(low_frequencies3)
figure(7); imshow(high_frequencies3 + 0.5);
vis = vis_hybrid_image(hybrid_image3);
figure(8); imshow(vis);
imwrite(low_frequencies3, 'low_frequencies3.jpg', 'quality', 95);
imwrite(high_frequencies3 + 0.5, 'high_frequencies3.jpg', 'quality', 95);
imwrite(hybrid_image3, 'hybrid_image3.jpg', 'quality', 95);
imwrite(vis, 'hybrid_image_scales3.jpg', 'quality', 95);




