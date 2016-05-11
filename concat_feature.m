function [ F ] = concat_feature(X_pyramid, X_prime_pyramid, l, i, j, L)
%CONCAT_FEATURE Concatenate the neighborhood around (i,j)
%               on levels l and l-1 for X and X'
%               Use a neighborhood size of 5 for level l, and
%               a size of 3 for level l-1.

global N_BIG;
global N_SMALL;
global NNF;
global nnf;
global NUM_FEATURES;
global G_big;
global G_small;
global end_idx;

X_fine = X_pyramid{l};
X_prime_fine = X_prime_pyramid{l};
[x_fine_height, x_fine_width, ~] = size(X_fine);

if l+1 <= L % In range, so make a coarse guy
  X_coarse = X_pyramid{l+1};
  X_prime_coarse = X_prime_pyramid{l+1};
  [x_coarse_height, x_coarse_width, ~] = size(X_coarse);
end

X_fine_nhood = zeros(N_BIG);
X_prime_fine_nhood = zeros(N_BIG);
X_coarse_nhood = zeros(N_SMALL);
X_prime_coarse_nhood = zeros(N_SMALL);

[ x_fine_start_i, x_fine_end_i, x_fine_start_j, x_fine_end_j, ...
  pad_top, pad_bot, pad_left, pad_right ] = ...
  get_indices( i, j, N_BIG, x_fine_height, x_fine_width );

% A or B
X_fine_nhood(pad_top:pad_bot, pad_left:pad_right)...
  = X_fine(x_fine_start_i : x_fine_end_i,...
  x_fine_start_j : x_fine_end_j, NUM_FEATURES);
X_fine_nhood = X_fine_nhood.* G_big; % Gaussian kernel

% A' or B'
X_prime_fine_nhood(pad_top:pad_bot, pad_left:pad_right) ...
  = X_prime_fine(x_fine_start_i : x_fine_end_i,...
  x_fine_start_j : x_fine_end_j, NUM_FEATURES);

X_prime_fine_nhood = X_prime_fine_nhood.* G_big;

if l+1 <= L
  [ x_coarse_start_i, x_coarse_end_i, x_coarse_start_j, x_coarse_end_j, ...
    pad_top, pad_bot, pad_left, pad_right, flag] = ...
    get_indices( floor(i/2), floor(j/2), N_SMALL, x_coarse_height, x_coarse_width );
  
  if flag == false
    X_coarse_nhood(pad_top:pad_bot, pad_left:pad_right)...
      = X_coarse(x_coarse_start_i : x_coarse_end_i,...
      x_coarse_start_j : x_coarse_end_j, NUM_FEATURES);
    
    X_coarse_nhood = X_coarse_nhood.* G_small;
    
    X_prime_coarse_nhood(pad_top:pad_bot, pad_left:pad_right) ...
      = X_prime_coarse(x_coarse_start_i : x_coarse_end_i,...
      x_coarse_start_j : x_coarse_end_j, NUM_FEATURES);
    X_prime_coarse_nhood = X_prime_coarse_nhood.* G_small;
    
    %     imshow(X_prime_coarse_nhood, 'InitialMagnification', 'fit');
    
    % Normalize
    %     X_coarse_nhood = X_coarse_nhood .* (sum(X_fine_nhood(:).^2) / sum(X_coarse_nhood(:).^2));
    %     X_prime_coarse_nhood = X_prime_coarse_nhood .* (sum(X_prime_fine_nhood(:).^2) / sum(X_prime_coarse_nhood(:).^2));
    
    %     X_coarse_nhood = X_coarse_nhood .* (sum(X_fine_nhood(:).^2) / sum(X_coarse_nhood(:)));
    %     X_prime_coarse_nhood = X_prime_coarse_nhood .* (sum(X_prime_fine_nhood(:).^2) / sum(X_prime_coarse_nhood(:)));
    
    %     X_fine = [X_fine_nhood; X_prime_fine_nhood];
    %     X_fine = (X_fine ./ sum(X_fine(:)));% * .5;
    %     X_fine_nhood = X_fine(1:size(X_fine_nhood, 1), :);
    %     X_prime_fine_nhood = X_fine(size(X_fine_nhood, 1)+1:end, :);
    %
    %     % sum(X_fine_nhood(:)) + sum(X_prime_fine_nhood(:))
    %     X_coarse = [X_coarse_nhood; X_prime_coarse_nhood];
    %     X_coarse = (X_coarse ./ sum(X_coarse(:)));% * .5;
    %     X_coarse_nhood = X_coarse(1:size(X_coarse_nhood, 1), :);
    %     X_prime_coarse_nhood = X_coarse(size(X_coarse_nhood, 1)+1:end, :);
    
    %     sum(X_coarse_nhood(:)) + sum(X_prime_coarse_nhood(:))
    
  end
end


% X_fine_nhood = X_fine_nhood / sum(X_fine_nhood);
% X_prime_fine_nhood = X_prime_fine_nhood / sum(X_prime_fine_nhood);
% X_coarse_nhood = X_coarse_nhood / sum(X_coarse_nhood);
% X_prime_coarse_nhood = X_prime_coarse_nhood / sum(X_prime_coarse_nhood);

F = zeros(1, NNF*2 + nnf*2);

% Begin filling in the concatenated feature vectors into F
%   Note that (i,j) are in terms of extended images

% This is neighborhood of A{l} or B{l}
F(1:NNF) = reshape(X_fine_nhood, 1, NNF);

% Only copies over the parts of B' (and A') that are already made
temp = X_prime_fine_nhood'; % <-- transpose this??????
temp = reshape(temp, 1, NNF);
temp(end_idx+1:end) = 0;
% otherTemp = reshape(temp, 5, 5);
% imshow(otherTemp', 'InitialMagnification', 'fit');
F(NNF+1:2*NNF) = temp;

% Edge case: make sure the l-1 level exists
if l+1 <= L
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