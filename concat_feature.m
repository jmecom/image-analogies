function [ F ] = concat_feature(X_pyramid, X_prime_pyramid, l, i, j, ...
  synth_i, synth_j)
%CONCAT_FEATURE Concatenate the neighborhood around (i,j)
%               on levels l and l-1 for X and X'
%               Use a neighborhood size of 5 for level l, and
%               a size of 3 for level l-1.

global N_BIG;
global N_SMALL;
global NNF;
global nnf;
global NUM_FEATURES;

border_big = floor(N_BIG/2);
border_small = floor(N_SMALL/2);

X_fine = X_pyramid{l};
X_prime_fine = X_prime_pyramid{l};
[x_fine_height, x_fine_width, ~] = size(X_fine);

if l-1 > 1
  X_coarse = X_pyramid{l-1};
  X_prime_coarse = X_prime_pyramid{l-1};
  [x_coarse_height, x_coarse_width, ~] = size(X_coarse);
end

% Gaussian filters up front
G_big = fspecial('Gaussian', [N_BIG N_BIG]);
G_small = fspecial('Gaussian', [N_SMALL N_SMALL]);
X_fine_nhood = zeros(N_BIG);
X_prime_fine_nhood = zeros(N_BIG);

%starting and ending indices

% [i j]
[ x_fine_start_i, x_fine_end_i, x_fine_start_j, x_fine_end_j, ...
  pad_top, pad_bot, pad_left, pad_right] = ...
  get_indices( i, j, N_BIG, x_fine_height, x_fine_width );

% % x_fine_start_i = max(i-border_big, 1);
%  x_fine_end_i = min(i+border_big, x_fine_height);
% % x_fine_start_j = max(j-border_big, 1);
%  x_fine_end_j = min(j+border_big, x_fine_width);


X_fine_nhood(pad_top:pad_bot, pad_left:pad_right)...
  = X_fine(x_fine_start_i : x_fine_end_i,...
  x_fine_start_j : x_fine_end_j, NUM_FEATURES);
X_fine_nhood = X_fine_nhood.* G_big;

X_prime_fine_nhood(pad_top:pad_bot, pad_left:pad_right) ...
  = X_prime_fine(x_fine_start_i : x_fine_end_i,...
  x_fine_start_j : x_fine_end_j, NUM_FEATURES);

imshow(X_prime_fine_nhood,'InitialMagnification','fit')
X_prime_fine_nhood = X_prime_fine_nhood.* G_big;


if l-1 > 1
[ x_coarse_start_i, x_coarse_end_i, x_coarse_start_j, x_coarse_end_j, ...
  pad_top, pad_bot, pad_left, pad_right] = ...
  get_indices( i, j, N_BIG, x_coarse_height, x_coarse_width );
  
  X_coarse_nhood(pad_top:pad_bot, pad_left:pad_right)...
    = X_coarse(x_coarse_start_i : x_coarse_end_i,...
    x_coarse_start_j : x_coarse_end_j, NUM_FEATURES);
  X_coarse_nhood = X_coarse_nhood.* G_small;
  
  X_prime_coarse_nhood(pad_top:pad_bot, pad_left:pad_right) ...
    = X_prime_coarse(x_coarse_start_i : x_coarse_end_i,...
    x_coarse_start_j : x_coarse_end_j, NUM_FEATURES);
  X_prime_coarse_nhood = X_prime_coarse_nhood.* G_small;

  % Normalize
  X_coarse_nhood = X_coarse_nhood .* (sum(X_fine_nhood(:).^2) / sum(X_coarse_nhood(:).^2));
  X_prime_coarse_nhood = X_prime_coarse_nhood .* (sum(X_prime_fine_nhood(:).^2) / sum(X_prime_coarse_nhood(:).^2));
end

F = zeros(1, NNF*2 + nnf*2);

% Begin filling in the concatenated feature vectors into F
%   Note that (i,j) are in terms of extended images

% This is neighborhood of A{l} or B{l}
F(1:NNF) = reshape(X_fine_nhood, 1, NNF);

% Only copies over the parts of B' (and A') that are already made
temp = X_prime_fine_nhood; % <-- transpose this??????
temp = reshape(temp, 1, NNF);
% end_idx = sub2ind([N_BIG N_BIG], border_big, border_big); % dbl check?
end_idx = sub2ind([N_BIG N_BIG], min(synth_i, 3), min(synth_j, 3));
temp(end_idx+1:end) = 0;

F(NNF+1:2*NNF) = temp;

% Edge case: make sure the l-1 level exists
if l-1 > 1
  F(2*NNF+1:2*NNF+nnf) = reshape(X_coarse_nhood, 1, nnf);
  F(2*NNF+nnf+1:end) = reshape(X_prime_coarse_nhood, 1, nnf);
end

% [i j]
% subplot(1,2,1);
% imshow(reshape(F(1:NNF), N_BIG, N_BIG));
% subplot(1,2,2);
% x_fine_start_i
% x_fine_end_i
% x_fine_start_j
% x_fine_end_j
% imshow(X_fine(x_fine_start_i:x_fine_end_i, x_fine_start_j:x_fine_end_j));


end