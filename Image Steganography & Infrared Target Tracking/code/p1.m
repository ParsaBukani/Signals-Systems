clc; clear; close all;

% Part 1: Define Mapset (2x32 cell array)

letters = 'abcdefghijklmnopqrstuvwxyz .,!";';
Mapset = cell(2,32);

for k = 1:32
    Mapset{1,k} = letters(k);
    Mapset{2,k} = dec2bin(k-1,5);
end

% Part 2:Encoding

function codedImage = coding(img, msg, mapset)
img = double(img);
if size(img,3) > 1
    img = rgb2gray(img);
end

% convert message to binary string
binMsg = '';
for ch = msg
    for j = 1:size(mapset,2)
        if ch == mapset{1,j}
            binMsg = [binMsg, mapset{2,j}];
            break;
        end
    end
end

if numel(binMsg) > numel(img)
    error('Message is too long for this image.');
end

flat = img(:);
for k = 1:length(binMsg)
    flat(k) = bitset(uint8(flat(k)), 1, str2double(binMsg(k)));
end

codedImage = reshape(flat, size(img));
codedImage = uint8(codedImage);
end

% Part 3

[file, path] = uigetfile({'*.jpg;*.png'});
pic = imread(fullfile(path, file));
pic = rgb2gray(pic);

msg = 'signal;';
codedPic = coding(pic, msg, Mapset);

imshowpair(pic, codedPic, 'montage');
title('Original (left)  |  Encoded (right)');

% Part 4

function msg = decoding(codedImg, mapset)
if size(codedImg,3) > 1
    codedImg = rgb2gray(codedImg);
end

bits = bitget(codedImg(:),1);       % read least significant bits
msg = '';
buffer = '';

for b = 1:length(bits)
    buffer = [buffer, num2str(bits(b))];  % collect bits one by one
    if mod(length(buffer),5) == 0         % every 5 bits → one char
        code = buffer(end-4:end);
        val = bin2dec(code);
        ch = mapset{1, val+1};
        msg = [msg, ch];
        if ch == ';'                      % stop when end symbol found
            break;
        end
    end
end

fprintf('Decoded message: %s\n', msg);
end


decodedMsg = decoding(codedPic, Mapset);
