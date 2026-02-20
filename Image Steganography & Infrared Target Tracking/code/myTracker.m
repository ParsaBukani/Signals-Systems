clc; clear; close all;

[vidName, vidPath] = uigetfile({'*.mp4;*.avi'}, 'Select an IR video file');
if isequal(vidName,0)
    disp('No video selected.'); return;
end
vidObj = VideoReader(fullfile(vidPath, vidName));

outName = 'tracked_output_clean.avi';
outVid = VideoWriter(outName, 'Motion JPEG AVI');
outVid.FrameRate = vidObj.FrameRate;
open(outVid);

% Read first frame
firstFrame = rgb2gray(readFrame(vidObj));
firstFrame = mat2gray(firstFrame);

% Let user mask static regions
figure; imshow(firstFrame);
title('Draw rectangles around static objects (trees, numbers), press Enter when done');
mask = false(size(firstFrame));

hold on;
while true
    h = drawrectangle('Color','cyan');
    wait(h);
    r = round(h.Position);
    if isempty(r), break; end
    mask(r(2):(r(2)+r(4)), r(1):(r(1)+r(3))) = true;
    answ = questdlg('Select another static area?','Continue','Yes','No','No');
    if strcmp(answ,'No'), break; end
end
hold off; close;

% Initialize previous frame
prevFrame = firstFrame;
prevFrame(mask) = 0;  % zero out masked areas

% Process remaining frames
while hasFrame(vidObj)
    currFrame = rgb2gray(readFrame(vidObj));
    currFrame = mat2gray(currFrame);
    currFrame(mask) = 0;  % ignore static areas

    % Frame differencing and filtering 
    diffFrame = imabsdiff(currFrame, prevFrame);
    motion = diffFrame > 0.05;
    motion = imgaussfilt(double(motion), 2) > 0.25;
    motion = bwareaopen(motion, 25);

    % Find moving regions
    stats = regionprops(motion, 'BoundingBox');

    % Convert to RGB and draw green boxes
    rgbFrame = repmat(currFrame, [1 1 3]);
    for k = 1:length(stats)
        box = round(stats(k).BoundingBox);
        x1 = max(1, box(1));
        y1 = max(1, box(2));
        x2 = min(size(rgbFrame,2), x1+box(3));
        y2 = min(size(rgbFrame,1), y1+box(4));
        % draw green border
        rgbFrame(y1:y2, [x1 x2], 1)=0; rgbFrame(y1:y2, [x1 x2], 2)=1; rgbFrame(y1:y2, [x1 x2], 3)=0;
        rgbFrame([y1 y2], x1:x2, 1)=0; rgbFrame([y1 y2], x1:x2, 2)=1; rgbFrame([y1 y2], x1:x2, 3)=0;
    end

    % Write to output video
    writeVideo(outVid, rgbFrame);

    % Update previous frame
    prevFrame = currFrame;
end

close(outVid);
disp(['Tracking finished. Output saved as ', outName]);
