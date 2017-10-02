function [x, y, confidence, scale, orientation] = get_interest_points(image, feature_width, threshold)
% Implement the Harris corner detector (See Szeliski 4.1.1) to start with.
% You can create additional interest point detector functions (e.g. MSER)
% for extra credit.
%
% If you're finding spurious interest point detections near the boundaries,
% it is safe to simply suppress the gradients / corners near the edges of
% the image.
%
% The lecture slides and textbook are a bit vague on how to do the
% non-maximum suppression once you've thresholded the cornerness score.
% You are free to experiment. Here are some helpful functions:
%  BWLABEL and the newer BWCONNCOMP will find connected components in 
% thresholded binary image. You could, for instance, take the maximum value
% within each component.
%  COLFILT can be used to run a max() operator on each sliding window. You
% could use this to ensure that every interest point is at a local maximum
% of cornerness.
[num_rows, num_cols] = size(image);
filter = fspecial('gaussian', [3 3], 0.5);
image = imfilter(image, filter);
[grad_im, dir_im, gx, gy] = gradient_fun(image);
x = [];
y = [];
point_ct = 0;
window_size = 16;
for i = 2*window_size:window_size:num_rows-2*window_size
    for j = 2*window_size:window_size:num_cols-2*window_size
        [M_mat, R_score] = compute_MR(i, j, gx, gy, window_size);
        if R_score > threshold
            point_ct = point_ct + 1;
            x(point_ct) = j+window_size/2;
            y(point_ct) = i+window_size/2;
        end
    end
end

x = x';
y = y';

scale = 1;
confidence = 1;
orientation = 1;

end

function [M, R] = compute_MR(row, col, gr_imagex, gr_imagey, win_size)
    % Define a window by the top left corner coordinates, (row, col)
    % (row,col) have to be integer values
    M = zeros(2,2);
    alpha = 0.05;
    for rows = row:row+win_size
        for cols = col:col+win_size
            Ix = gr_imagex(rows, cols);
            Iy = gr_imagey(rows, cols);
            M = M+[Ix^2 Ix*Iy; Ix*Iy Iy^2];
        end
    end
    R = det(M) - alpha*trace(M)^2; 
end










