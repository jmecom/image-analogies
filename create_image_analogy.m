function [ B_prime ] = create_image_analogy( A, A_prime, B )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Neightborhood size
N = 5;
n = 3;

[B_height, B_width, ~] = size(B);
[A_height, A_width, ~] = size(A);

%% Construct Gaussian pyramids for A, A' and B
A_pyramid = {A};
A_prime_pyramid = {A_prime};
B_pyramid = {B};

while (A_height >= 50) && (A_width >= 50)
  A_pyramid{end+1} = impyramid(A_pyramid{end}, 'reduce');
  A_prime_pyramid{end+1} = impyramid(A_prime_pyramid{end}, 'reduce');
  B_pyramid{end+1} = impyramid(B_pyramid{end}, 'reduce');
  
  [A_height, A_width, ~] = size(A_pyramid{end});
end

L = size(A_pyramid, 2);

%% Compute features ?
% ...

% Number of features
F = 3;

% Initialize the search structures
s = zeros(B_height, B_width);

%% Feature vectors for ANN
% Extend border for each level to catch edge cases
A_pyramid_border = {};
A_prime_pyramid_border = {};
B_pyramid_border = {};
for i=1:L
  A_pyramid_border{i} = extend_image(A_pyramid{i}, N/2);
  A_prime_pyramid_border{i} = extend_image(A_prime_pyramid{i}, N/2);
  B_pyramid_border{i} = extend_image(B_pyramid{i}, N/2);
end

% Show image
% for i=1:L
%   subplot(1,L,i);
%   imshow(uint8(A_prime_pyramid_border{i}));
% end

% Make feature vector for ANN
% Concat neightborhood of each pixel at every level
A_features = {};
B_features = {}; zeros(B_height, B_width, N * N * F);
border = floor(N/2);

%% Test
border = floor(N/2);

for l = 1:L
  A_l = A_pyramid_border{l};
  B_l = B_pyramid_border{l};

  % init features of A from size of
  [A_height, A_width, ~] = size(A_pyramid{l});
  [B_height, B_width, ~] = size(B_pyramid{l});
  
  A_features{l} = zeros(A_height * A_width, N * N * F);
  B_features{l} = zeros(B_height * B_width, N * N * F);

  for i = 1:A_height
    for j = 1:A_width
      A_features{l}(sub2ind([A_height A_width], i, j), :) = reshape( ...
        A_l(i:i+4, j:j+4, :), ...
        1, N * N *F);
    end
  end

  for i = 1:B_height
    for j = 1:B_width
      B_features{l}(sub2ind([B_height B_width], i, j), :) = reshape( ...
        B_l(i:i+4, j:j+4, :), ...
        1, N * N *F);
    end
  end
end

% % Test: Show the neighborhoods
% [A_height, A_width, ~] = size(A_pyramid{l});
% for i = 1:length(A_features{1})
%     subplot(1,2,1);
%     imshow(uint8(reshape(A_features{1}(i,:),5,5,3)), 'InitialMagnification','fit');
%     subplot(1,2,2);
%     [ii, jj] = ind2sub(size(A_pyramid_border{1}), i);
%     imshow(uint8(A_pyramid_border{1}(ii:ii+4, jj:jj+4, :)), 'InitialMagnification','fit');  
% end

% for l = 1:L
%   A_l = A_pyramid_border{l};
%   B_l = B_pyramid_border{l};
%   
%   [A_height, A_width, ~] = size(A_pyramid{l});
%   [B_height, B_width, ~] = size(B_pyramid{l});
%   A_features{l} = zeros(A_height, A_width, N * N * F);
%   B_features{l} = zeros(B_height, B_width, N * N * F);
%   
%   for i = border:-1:-border
%     for j = border:-1:-border
%       A_shift = circshift(A_l, [i j]);
%       B_shift = circshift(B_l, [i j]);
%       
%       start = F * (i + 2) * (j + 2) + 1;
%       fin = ((i + 2) * (j + 2) + 1) * F;
%       
%       A_features{l}(:,:,start:fin) = ...
%         A_shift(border+1:end-border, border+1:end-border, :);
%       B_features{l}(:,:,start:fin) = ...
%         B_shift(border+1:end-border, border+1:end-border, :);
%     end
%   end
%   
%   A_features{l} = reshape(A_features{l}, A_height*A_width, N*N*F);
%   B_features{l} = reshape(B_features{l}, B_height*B_width, N*N*F);
% end


B_prime = 0;
end

