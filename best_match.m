function [ best_i, best_j ] = best_match( A_pyramid, A_pyramid_extend, ...
  A_prime_pyramid_extend,  B_pyramid, B_pyramid_extend, ...
B_prime_pyramid_extend, s_pyramid, A_features, B_features, l, i, j)
%BEST_MATCH ...
%           The pixel (i,j) passed in is in terms of NON-EXTENDED pyramid

global N_BIG;

% Edit the passed-in indices to be in terms of extended matrices
% So, (1,1) --> (3,3) which is the true starting point in an extended image
i = i + floor(N_BIG/2);
j = j + floor(N_BIG/2);

synth_i = i - 1;
synth_j = j - 1;

% NOTE: The indicies returned here are in terms of the extended pyramids ??
% [best_app_i, best_app_j] = best_approximate_match(A_features, A_pyramid, ...
% B_pyramid, B_features, l, i, j);

[best_coh_i, best_coh_j] = best_coherence_match(A_pyramid_extend, ...
  A_prime_pyramid_extend, B_pyramid_extend, B_prime_pyramid_extend, ...
  s_pyramid, l, i, j);

% F_p_app = concat_feature(A_pyramid_extend, A_prime_pyramid_extend, l, ... 
%   best_app_i, best_app_j, synth_i, synth_j);

% F_p_coh = concat_feature(A_pyramid_extend, A_prime_pyramid_extend, l, ... 
%   best_coh_i, best_coh_j, synth_i, synth_j);
% 
% F_q = concat_feature(B_pyramid_extend, B_prime_pyramid_extend, l, ... 
%   i, j, synth_i, synth_j);

% TODO: distances !!!!! (gaussian kernel, normalization, etc.)

% TODO: for now just return best_app_i, best_app_j for testing
% Once this works we can add in coherence to complete the algorithm.
% best_i = best_app_i;
% best_j = best_app_j;

best_i = best_coh_i;
best_j = best_coh_j;

% Convert back? Don't think is necessary.
% best_i = best_i - floor(N_BIG/2);
% best_j = best_j - floor(N_BIG/2);

end

