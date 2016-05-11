function [ B_prime ] = create_image_analogy( A, A_prime, B )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

global N_BIG;
global NUM_FEATURES;
global NNF;

[B_height, B_width, ~] = size(B);
[A_height, A_width, ~] = size(A);

%% Create luminance maps
A = rgb2ntsc(A);
A_prime = rgb2ntsc(A_prime);
B = rgb2ntsc(B);

%% Construct Gaussian pyramids for A, A' and B
A_pyramid = {A};
A_prime_pyramid = {A_prime};
B_pyramid = {B};
B_prime_pyramid = {zeros(size(B))};
s_pyramid = {zeros(B_height, B_width, 2)};

% Was 50, 50
while (A_height >= 15) && (A_width >= 15)
  A_pyramid{end+1} = impyramid(A_pyramid{end}, 'reduce');
  A_prime_pyramid{end+1} = impyramid(A_prime_pyramid{end}, 'reduce');
  B_pyramid{end+1} = impyramid(B_pyramid{end}, 'reduce');
  B_prime_pyramid{end+1} = impyramid(B_prime_pyramid{end}, 'reduce');
  s_pyramid{end+1} = impyramid(s_pyramid{end}, 'reduce');
  [A_height, A_width, ~] = size(A_pyramid{end});
end

L = size(A_pyramid, 2);

% Extended pyramids, for ANN only
A_pyramid_extend = cell(L);
B_pyramid_extend = cell(L);

s_pyramid = cell(L);
% [B_extend_h, B_extend_w, ~] = size(B_pyramid_extend{1});

for l=1:L
  A_pyramid_extend{l} = extend_image(A_pyramid{l}, N_BIG/2, NUM_FEATURES);
  B_pyramid_extend{l} = extend_image(B_pyramid{l}, N_BIG/2, NUM_FEATURES);
  s_pyramid{l} = zeros(B_height + 4, B_width + 4, 2);
end

%% Make feature vectors used for ANN
% Extend border for each level to catch edge cases

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
      % Get the neighborhood around (i,j), reshape it, and place it
      % into A features.
      A_features{l}(sub2ind([A_height A_width], i, j), :) = ...
        reshape(A_l(i:i+N_BIG-1, j:j+N_BIG-1, NUM_FEATURES), 1, NNF);
    end
  end
  
  for i = 1:B_height
    for j = 1:B_width
      B_features{l}(sub2ind([B_height B_width], i, j), :) = ...
        reshape(B_l(i:i+N_BIG-1, j:j+N_BIG-1, NUM_FEATURES), 1, NNF);
    end
  end
  
end


fprintf('Finding best match...\n\n');

%% Main loop, find the best match

% TODO: doing single scale for quicker testin right now -- remove this
% line.
% L = 1;
for l = L:-1:1
  fprintf('\nl: %d/%d\n===========\n', l, L);
  % Loop over B'
  B_prime_l = B_prime_pyramid{l};
  [height, width, ~] = size(B_prime_l);
  for i = 1:height
    fprintf('i: %d/%d\n', i, height);
    for j = 1:width
      % Find the best match
      [best_i, best_j] = best_match(A_pyramid, A_prime_pyramid, B_pyramid, B_prime_pyramid,...
        s_pyramid, A_features, B_features, l, L, i, j);
      
      % Save it into s
      s_pyramid{l}(i,j,1) = best_i;
      s_pyramid{l}(i,j,2) = best_j;
      
      % Write to B'
      %       [height width]
      %       [i j]
      %       [best_i best_j]
      %       size(A_prime_pyramid{l})
%       A_prime_pyramid{l}(best_i, best_j, 1);
      %       if strcmp(type, 'app')
      B_prime_pyramid{l}(i, j, 1) = A_prime_pyramid{l}(best_i, best_j, 1);
      %       else
      %         B_prime_pyramid{l}(i, j, 1) = B_prime_pyramid{l}(best_i, best_j, 1);
      %       end
      
      B_prime_pyramid{l}(i, j, 2:3) = B_pyramid{l}(i, j, 2:3);
    end
  end
end

B_prime = ntsc2rgb(B_prime_pyramid{1});
imshow(B_prime);

end

