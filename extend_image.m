function [ result ] = extend_image( image, border, layers )
%EXTEND_IMAGE Extend the borders of the image by ext_size

% global NUM_FEATURES;

border = floor(border);
[h, w, ~] = size(image);
result = zeros(h + 2 * border, w + 2 * border);

% Put original pic in center
result(border+1:end-border, border+1:end-border) = image(:,:,1:layers); 

% We just want to leave it as 0's so it doesn't add any weight

% Fill in borders
result(1:border, border+1:end-border) = repmat(image(1,:,1:layers), border, 1);
result(end-border+1:end, border+1:end-border) = repmat(image(end,:,1:layers),border, 1);
result(border+1:end-border, 1:border) = repmat(image(:,1,1:layers),1, border);
result(border+1:end-border, end-border+1:end) = repmat(image(:,end,1:layers),1, border);

% Fill in corners
result(1:border,1:border) = repmat(image(1,1,1:layers), border, border);
result(1:border,end-border+1:end) = repmat(image(1,end,1:layers), border, border);
result(end-border+1:end,1:border) = repmat(image(end,1,1:layers), border, border);
result(end-border+1:end,end-border+1:end) = repmat(image(end,end,1:layers), border, border);

% subplot(1,2,1);
% imshow(uint8(image));
% subplot(1,2,2);
% imshow(uint8(result));

end

