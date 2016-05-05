function [ B_prime ] = create_image_analogy( A, A_prime, B )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

global N_BIG;
global NNF;

[B_height, B_width, ~] = size(B);
[A_height, A_width, ~] = size(A);

%% Construct Gaussian pyramids for A, A' and B
A_pyramid = {A};
A_prime_pyramid = {A_prime};
B_pyramid = {B};
B_prime_pyramid = {zeros(size(B))};
s_pyramid = {zeros(B_height, B_width, 2)};

while (A_height >= 50) && (A_width >= 50)
  A_pyramid{end+1} = impyramid(A_pyramid{end}, 'reduce');
  A_prime_pyramid{end+1} = impyramid(A_prime_pyramid{end}, 'reduce');
  B_pyramid{end+1} = impyramid(B_pyramid{end}, 'reduce');
  B_prime_pyramid{end+1} = impyramid(B_prime_pyramid{end}, 'reduce');
  s_pyramid{end+1} = impyramid(s_pyramid{end}, 'reduce');
  
  [A_height, A_width, ~] = size(A_pyramid{end});
end

L = size(A_pyramid, 2);

%% Compute features
% TODO: Make luminance maps.

%% Make feature vectors used for ANN
% Extend border for each level to catch edge cases
A_pyramid_extend = cell(L);
A_prime_pyramid_extend = cell(L);
B_pyramid_extend = cell(L);
B_prime_pyramid_extend = cell(L);
for i=1:L
  A_pyramid_extend{i} = extend_image(A_pyramid{i}, N_BIG/2);
  A_prime_pyramid_extend{i} = extend_image(A_prime_pyramid{i}, N_BIG/2);
  B_pyramid_extend{i} = extend_image(B_pyramid{i}, N_BIG/2);
  B_prime_pyramid_extend{i} = extend_image(B_prime_pyramid{i}, N_BIG/2);
end

% Concat neightborhood of each pixel at every level
A_features = cell(L);
B_features = cell(L);

for l = 1:L
  A_l = A_pyramid_extend{l};
  B_l = B_pyramid_extend{l};
  
  [A_height, A_width, ~] = size(A_pyramid{l});
  [B_height, B_width, ~] = size(B_pyramid{l});
  
  A_features{l} = zeros(A_height * A_width, NNF);
  B_features{l} = zeros(B_height * B_width, NNF);
  
  for i = 1:A_height
    for j = 1:A_width
      A_features{l}(sub2ind([A_height A_width], i, j), :) = ...
        reshape(A_l(i:i+N_BIG-1, j:j+N_BIG-1, :), 1, NNF);
    end
  end
  
  for i = 1:B_height
    for j = 1:B_width
      B_features{l}(sub2ind([B_height B_width], i, j), :) = ...
        reshape(B_l(i:i+N_BIG-1, j:j+N_BIG-1, :), 1, NNF);
    end
  end
  
end

% % Test: Show the neighborhoods to confirm this works.
% [A_height, A_width, ~] = size(A_pyramid{l});
% for i = 1:length(A_features{1})
%     subplot(1,2,1);
%     imshow(uint8(reshape(A_features{1}(i,:),5,5,3)), 'InitialMagnification','fit');
%     subplot(1,2,2);
%     [ii, jj] = ind2sub(size(A_pyramid_border{1}), i);
%     imshow(uint8(A_pyramid_border{1}(ii:ii+4, jj:jj+4, :)), 'InitialMagnification','fit');
% end

fprintf('Finding best match...\n\n');

%% Main loop, find the best match
L=1; % Temporary!!!!!!!!!!!! FIXME
for l = 1:L
  fprintf('l: %d\n ======= \n', l);
  % Loop over B'
  B_prime_l = B_prime_pyramid{l};
  [height, width, ~] = size(B_prime_l);
  for i = 1:height
    fprintf('i: %d\n', i);
    for j = 1:width
      % Find the best match
      [best_i, best_j] = best_match(A_pyramid_extend, ...
        A_prime_pyramid_extend, B_pyramid_extend, ...
        B_prime_pyramid_extend, s_pyramid, A_features, B_features, l, i, j);
      
      % Save it into s
      s_pyramid{l}(i,j,:) = [best_i best_j];
      
      % Write to B'
      % TODO: This is wrong, as we're just lifting pixels from A' into
      % B... which isn't quite right.
      B_prime_pyramid{l}(i,j,:) = A_prime_pyramid{l}(best_i,best_j,:);
    end
  end
end

B_prime = B_prime_pyramid{1};
% imshow(uint8(A_prime_pyramid{1}));
imshow(uint8(B_prime));
end

