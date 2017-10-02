function output = my_imfilter(image, filter)
    % mirrors functionality of the built in imfilter function
    image_pad = pad_image(image, filter);
    filter = rot90(filter, 2);
    output = [];
    [image_height, image_width, colors] = size(image);
    [filter_height, filter_width] = size(filter);
    rows_to_pad = floor((filter_height-1)/2);
    cols_to_pad = floor((filter_width-1)/2);

    for p = 1:colors
        for m = (1+rows_to_pad):(rows_to_pad+image_height) % 2:4
            for n = (1+cols_to_pad):(cols_to_pad+image_width) % 2:4
                p_val = filter_pixel([m n p], image_pad, filter);
                output(m-rows_to_pad, n-cols_to_pad, p) = p_val;
            end
        end
    end 
end

function pix_val = filter_pixel(index, image_padded, filter)
% returns the filtered pixel value at a specified index
[f_height, f_width] = size(filter);
row_bound_low = index(1) - floor(f_height/2);
row_bound_upp = index(1) + floor(f_height/2);
col_bound_low = index(2) - floor(f_width/2);
col_bound_upp = index(2) + floor(f_width/2);
color = index(3);
sub_mat = image_padded(row_bound_low:row_bound_upp, col_bound_low:col_bound_upp, color);
pix_val = sum(sum(sub_mat.*filter));
end

function padded_image = pad_image(image, filter)
    % Takes an image and pads it appropriately given a filter
    [image_height, image_width] = size(image);
    [filter_height, filter_width] = size(filter);
    rows_to_pad = floor((filter_height-1)/2);
    cols_to_pad = floor((filter_width-1)/2);
    padded_image = padarray(image, [rows_to_pad cols_to_pad]);
end