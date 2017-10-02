% Local Feature Stencil Code
% Written by James Hays for CS 143 @ Brown / CS 4476/6476 @ Georgia Tech

% Returns a set of feature descriptors for a given set of interest points. 

% 'image' can be grayscale or color, your choice.
% 'x' and 'y' are nx1 vectors of x and y coordinates of interest points.
%   The local features should be centered at x and y.
% 'feature_width', in pixels, is the local feature width. You can assume
%   that feature_width will be a multiple of 4 (i.e. every cell of your
%   local SIFT-like feature will have an integer width and height).
% If you want to detect and describe features at multiple scales or
% particular orientations you can add input arguments.

% 'features' is the array of computed features. It should have the
%   following size: [length(x) x feature dimensionality] (e.g. 128 for
%   standard SIFT)
% clear all
% 
% image = im2double(rgb2gray(imread('../data/Notre Dame/921919841_a30df938f2_o.jpg')));
% % [gradient_grid, angle_grid] = make_cells(400.5, 900.5, image);
% % histogram = make_hist(gradient_grid, angle_grid)
% x = [500 500.5 70.23 1000.27]';
% y = [900 900.5 425.8 800.39]';
% feature_array = get_features(image, x, y, 16)

function [features] = get_features(image, x, y, feature_width)
% To start with, you might want to simply use normalized patches as your
% local feature. This is very simple to code and works OK. However, to get
% full credit you will need to implement the more effective SIFT descriptor
% (See Szeliski 4.1.2 or the original publications at
% http://www.cs.ubc.ca/~lowe/keypoints/)
%
% Your implementation does not need to exactly match the SIFT reference.
% Here are the key properties your (baseline) descriptor should have:
%  (1) a 4x4 grid of cells, each feature_width/4. 'cell' in this context
%    nothing to do with the Matlab data structue of cell(). It is simply
%    the terminology used in the feature literature to describe the spatial
%    bins where gradient distributions will be described.
%  (2) each cell should have a histogram of the local distribution of
%    gradients in 8 orientations. Appending these histograms together will
%    give you 4x4 x 8 = 128 dimensions.
%  (3) Each feature should be normalized to unit length
%
% You do not need to perform the interpolation in which each gradient
% measurement contributes to multiple orientation bins in multiple cells
% As described in Szeliski, a single gradient measurement creates a
% weighted contribution to the 4 nearest cells and the 2 nearest
% orientation bins within each cell, for 8 total contributions. This type
% of interpolation probably will help, though.
%
% You do not have to explicitly compute the gradient orientation at each
% pixel (although you are free to do so). You can instead filter with
% oriented filters (e.g. a filter that responds to edges with a specific
% orientation). All of your SIFT-like feature can be constructed entirely
% from filtering fairly quickly in this way.
%
% You do not need to do the normalize -> threshold -> normalize again
% operation as detailed in Szeliski and the SIFT paper. It can help, though.
%
% Another simple trick which can help is to raise each element of the final
% feature vector to some power that is less than one.
 
features = zeros(size(x, 1), 128);
% image = imfilter(image, fspecial('gaussian', [3 3], 2));

for i = 1:size(x, 1) % iterate for the number of interest points
    histo = [];
    r_ctr = y(i);
    c_ctr = x(i);
    for rows = r_ctr-8:4:r_ctr+4
        for cols = c_ctr-8:4:c_ctr+4
            [temp_gr_grid, temp_ang_grid] = make_cells(rows, cols, image);
            temp_histobaby = make_hist(temp_gr_grid, temp_ang_grid);
            histo = cat(2, histo, temp_histobaby);
        end
    end
    histo = normr(histo);
    features(i,:) = histo;
end

end

function hist = make_hist(gr_grid, ang_grid)
    g_filter = fspecial('gaussian', [3 3], 5);
    gr_grid = imfilter(gr_grid, g_filter);
    ang_grid = imfilter(ang_grid, g_filter);
    hist = [0 0 0 0 0 0 0 0];
    for row = 1:4
        for col = 1:4
            ang_grid(row,col);
            bin = sort_into_bin(ang_grid(row,col));
            hist(bin) = hist(bin)+gr_grid(row,col);
        end
    end
end

function bin_num = sort_into_bin(angle)
    if angle > 0 && angle <= 44 || angle == 0
        bin_num = 1;
    elseif angle > 44 && angle <= 89
        bin_num = 2;
    elseif angle > 89 && angle <= 134
        bin_num = 3;
    elseif angle > 134 && angle <= 179
        bin_num = 4;
    elseif angle > 179 && angle <= 224
        bin_num = 5;
    elseif angle > 224 && angle <= 269
        bin_num = 6;
    elseif angle > 269 && angle <= 314
        bin_num = 7;
    elseif angle > 314 && angle <= 360
        bin_num = 8;
    end
end

function [grad_grid, angle_grid] = make_cells(row_start, col_start, image)
    % Creates a grid of gradients and a grid of angles corresponding to
    % the gradient directions
    % pass in the image and coordinates
    % row_start and col_start should be the coordinates of the top left of
    % the box you want to create
    % row_start and col_start will be subpixel coordinates
    
    % initialize the grids
    grad_grid = zeros(4,4);
    angle_grid = zeros(4,4);
    row_ct = 0;
    col_ct = 0;
    for i = row_start:row_start+3
        row_ct = row_ct+1;
        col_ct = 0;
        for j = col_start:col_start+3
            col_ct = col_ct+1;
            % maybe later you should make a function that finds the
            % weighted interpolated gradient at a single point
            xg = bint(i, j+1, image)-bint(i, j, image);
            yg = bint(i+1, j, image)-bint(i, j, image);
            g_mag = sqrt(xg^2 + yg^2);
            ang = atan2d(yg, xg); % value from 0°-360°
            if ang<0
                ang = ang+360;
            end
            grad_grid(row_ct, col_ct) = g_mag;
            angle_grid(row_ct, col_ct) = ang;
        end
    end
end

function val = bint(row, col, image)
    % returns the bilinear interpolated value at the subpixel coordinate
    % row and col are subpixel coordinates
    row_floor = floor(row);
    row_ceil = floor(row+1);
    col_floor = floor(col);
    col_ceil = floor(col+1);
    top_left_val = image(row_floor, col_floor);
    top_right_val = image(row_floor, col_ceil);
    bot_left_val = image(row_ceil, col_floor);
    bot_right_val = image(row_ceil, col_ceil);
    mat = [bot_left_val top_left_val; bot_right_val top_right_val];
    xmat = [col_ceil-col col-col_floor];
    ymat = [row-row_floor; row_ceil-row];
    val = xmat*mat*ymat;
end






