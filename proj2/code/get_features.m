% Features is the array of features
% length(x) x 128 for a standard SIFT

function [features] = get_features(image, x, y, feature_width)
% filter = fspecial('gaussian', [5 5], 10);
% image = imfilter(image, filter);
% imshow(image);
[gr_image, dir_im, gr_x, gr_y] = gradient_fun(image);

num_points = size(x,1);
features = zeros(num_points, 128);
for i = 1:num_points
    features(i,:) = gen_feature(y(i), x(i), gr_image, dir_im);
    features(i,:) = normr(features(i,:));
    for k = 1:128
        if features(i,k) > 0.2
            features(i,k) = 0.2;
        end
    end
    features(i,:) = normr(features(i,:));
end

end

function [feat] = gen_feature(row, col, gradient, direction)
    feat = [];
    for r = row-8:4:row+4
        for c = col-8:4:col+4
            histo8 = gen_8hist(r, c, gradient, direction);
            feat = cat(2, feat, histo8);
        end
    end
end


function [hist] = gen_8hist(row, col, grad, dir)
    hist = zeros(1,8);
    row = floor(row);
    col = floor(col);
    for r = row:row+3
        for c = col:col+3
            mag = grad(r, c);
            ang = dir(r, c);
            bin = sort_into_bin(ang);
            hist(bin) = hist(bin)+mag;
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

