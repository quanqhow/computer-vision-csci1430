function [gradient_image, dir_image, grad_image_x, grad_image_y] = gradient_fun(image)
    [rows, cols] = size(image);
    gradient_image = zeros(size(image));
    dir_image = zeros(size(image));
    grad_image_x = imfilter(image, fspecial('sobel')', 'replicate');
    grad_image_y = imfilter(image, fspecial('sobel'), 'replicate');
    for i = 1:rows
        for j = 1:cols
            gradient_image(i, j) = (grad_image_x(i, j)^2 + grad_image_y(i, j)^2)^0.5;
            abs_angle = atan2d(grad_image_y(i, j), grad_image_x(i, j));
            if abs_angle < 0
                abs_angle = abs_angle + 360;
            end
            dir_image(i, j) = abs_angle;
        end
    end
    
end