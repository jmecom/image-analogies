function [ F ] = concat_feature(X_pyramid, X_prime_pyramid, l, i, j)
%CONCAT_FEATURE Concatenate the neighborhood around (i,j)
%               on levels l and l-1 for X and X'
%               Use a neighborhood size of 5 for level l, and
%               a size of 3 for level l-1.

global N_BIG;
global N_SMALL;
global NNF;
global nnf;

border_big = floor(N_BIG/2);
border_small = floor(N_SMALL/2);

X_fine = X_pyramid{l};
X_coarse = X_pyramid{l-1};
X_prime_fine = X_prime_pyramid{l};
X_prime_coarse = X_prime_pyramid{l-1};

F = zeros(1, NNF*2 + nnf*2);

% Begin filling in the concatenated feature vectors into F
%   Note that (i,j) are in terms of extended images

% This is neighborhood of A{l} or B{l}
F(1:NNF) = reshape(X_fine(i-border_big:i+border_big, ...
  j-border_big:j+border_big, :), 1, NNF);

% Only copies over the parts of B' (and A') that are already made
temp = X_prime_fine(i-border_big:i+border_big, ...
  j-border_big:j+border_big, :)'; % <-- note the transpose!
temp = reshape(temp, 1, NNF);
end_idx = ind2sub([N_BIG N_BIG], border_big, border_big); % dbl check?
temp(end_idx+1:end) = 0;

F(NNF+1:2*NNF) = temp;

% Edge case: make sure the l-1 level exists
if l-1 < 1
  F(2*NNF+1:2*NNF+nnf) = reshape(X_coarse(i-border_small:i+border_small, ...
    j-border_small:j+border_small, :), 1, nnf);
  F(2*NNF+nnf+1:end) = reshape(X_prime_coarse(i-border_small:i+border_small, ...
    j-border_small:j+border_small, :), 1, nnf);
end

end