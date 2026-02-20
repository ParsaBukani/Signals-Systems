clc; clear; close all;

% part 1
[filename, pathname] = uigetfile({'*.jpg;*.png;*.jpeg;*.bmp', 'Image Files (*.jpg, *.png, *.jpeg, *.bmp)'}, ...
    'Select the license plate image');

img_path = fullfile(pathname, filename);
plate_img = imread(img_path);

% part 2
resized_img = imresize(plate_img, [300 500]);

% part 3
function gray_img = mygrayfun(image)
    R = double(image(:,:,1));
    G = double(image(:,:,2));
    B = double(image(:,:,3));

    gray_img = 0.299 * R + 0.578 * G + 0.114 * B;
    gray_img = gray_img / 255;
end

gray_img = mygrayfun(resized_img);

figure;
imshow(gray_img);
title('Grayscale Image (Custom Conversion)');

% part 4
function binary_img = mybinaryfun(gray_img, threshold)
    binary_img = gray_img > threshold;
end

threshold = 0.5;
binary_img = mybinaryfun(gray_img, threshold);

figure;
imshow(binary_img);
title(['Binary Image (threshold = ', num2str(threshold), ')']);

% part 5
function cleaned = myremovecom(binary_img, n)
    [rows, cols] = size(binary_img);
    visited = false(rows, cols);
    cleaned = binary_img;

    for i = 1:rows
        for j = 1:cols
            % Find one connected component
            if binary_img(i, j) == 0 && ~visited(i, j)
                [component_pixels, visited] = dfs(binary_img, i, j, visited);

                % Remove it if smaller than threshold
                if size(component_pixels, 1) < n
                    for k = 1:size(component_pixels, 1)
                        cleaned(component_pixels(k,1), component_pixels(k,2)) = 1;
                    end
                end
            end
        end
    end
end

function [pixels, visited] = dfs(binary_img, x, y, visited)
    [rows, cols] = size(binary_img);
    stack = [x, y];
    pixels = [];

    while ~isempty(stack)
        [cx, cy] = deal(stack(end,1), stack(end,2));
        stack(end,:) = []; % pop

        if cx<1 || cx>rows || cy<1 || cy>cols
            continue;
        end
        if visited(cx,cy) || binary_img(cx,cy) == 1
            continue;
        end

        visited(cx,cy) = true;
        pixels = [pixels; cx, cy];

        % 4-connected neighbors
        stack = [stack; cx-1, cy];
        stack = [stack; cx+1, cy];
        stack = [stack; cx, cy-1];
        stack = [stack; cx, cy+1];
    end
end

min_size = 250;  
clean_img = myremovecom(binary_img, min_size);

figure;
imshow(clean_img);
title(['Cleaned Binary Image (removed objects < ', num2str(min_size), ' pixels)']);

% part 6
function [labeled, num] = mysegmentation(binary_img)
    [rows, cols] = size(binary_img);
    visited = false(rows, cols);
    labeled = zeros(rows, cols);
    label = 0;

    for i = 1:rows
        for j = 1:cols
            % Found a new black component (pixel == 0)
            if binary_img(i, j) == 0 && ~visited(i, j)
                label = label + 1;
                [component_pixels, visited] = dfs(binary_img, i, j, visited);

                % Assign the same label to all connected pixels
                for k = 1:size(component_pixels, 1)
                    labeled(component_pixels(k,1), component_pixels(k,2)) = label;
                end
            end
        end
    end

    num = label; % number of segments
end 

[L, num] = mysegmentation(clean_img);

colored_labels = label2rgb(L, 'jet', 'k', 'shuffle'); 
figure; imshow(colored_labels);
title(['Segmented Components: ', num2str(num)]);

% part 7
function recognized_text = recognize_plate(segmented_img, num_segments, template_dir, threshold)
    recognized_text = '';

    % Find bounding boxes of each segment
    boxes = zeros(num_segments, 3); % [index, min_col, mean_row]
    for k = 1:num_segments
        [r, c] = find(segmented_img == k);
        if isempty(r), continue; end
        boxes(k, :) = [k, min(c), mean(r)];
    end

    % Sort by x-position (left to right)
    boxes = sortrows(boxes, 2);
    valid_indices = boxes(:, 1);

    % Character recognition
    for idx = valid_indices'
        mask = (segmented_img == idx);
        [r, c] = find(mask);
        if isempty(r), continue; end
        char_img = mask(min(r):max(r), min(c):max(c));
        char_img = imresize(char_img, [50 30]);

        best_corr = 0;
        best_char = '';
        templates = dir(fullfile(template_dir, '*.png'));
        templates = [templates; dir(fullfile(template_dir, '*.bmp'))];

        for t = 1:length(templates)
            temp = imread(fullfile(template_dir, templates(t).name));
            temp = imresize(temp, [50 30]);
            corr_val = corr2(double(char_img), double(temp));

            if corr_val > best_corr
                best_corr = corr_val;
                [~, name, ~] = fileparts(templates(t).name);
                best_char = upper(name);
            end
        end

        % Accept only if above threshold
        if best_corr >= threshold
            recognized_text = [recognized_text best_char];
        end
    end
end

detection_threshold = 0.4;
template_dir = 'p1/Map Set'; 
recognized_text = recognize_plate(L, num, template_dir, detection_threshold);

% part 8
fid = fopen('recognized_plate.txt', 'w');
fprintf(fid, '%s\n', recognized_text);
fclose(fid);

disp(['Recognized Plate: ', recognized_text]);