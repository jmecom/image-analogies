function [ best_coh_i, best_coh_j ] = best_coherence_match( A_pyramid_extend, ...
  A_prime_pyramid_extend, B_pyramid_extend, B_prime_pyramid_extend, ...
  s_pyramid, l, i, j )
%BEST_COHERENCE_MATCH

global N_BIG;
% global N_SMALL;

% q = i,j

[h, w, ~] = size(B_pyramid_extend{1});
h = h - N_BIG - 1;
w = w - N_BIG - 1;

border_big = floor(N_BIG/2);
% border_small = floor(N_SMALL/2);

% [i j]

F_q = concat_feature(B_pyramid_extend, B_prime_pyramid_extend, ...
  l, i, j, i-1, j-1);

min_dist = inf;
best_coh_i = -1;
best_coh_j = -1;

% Loop over extend image
for ii = i-border_big:i+border_big
  for jj = j-border_big:j+border_big
    
    [i j]
    [ii jj]
    % Done, (i,j) is the first un-synthesized pixel
    if ii == i && jj == j
      return
    end
    
%     [s_i, s_j] = s_pyramid{l}(ii,jj,:);
%     size(s_pyramid{l})
    s_i = s_pyramid{l}(ii,jj,1)
    s_j = s_pyramid{l}(ii,jj,2)
    
    F_sr_i = s_i + (i - ii) % this is a problem for when s is not yet
    F_sr_j = s_j + (j - jj) % set, we solve this by just doing
                             % approx match only for first 3 rows.
    F_sr = concat_feature(A_pyramid_extend, A_prime_pyramid_extend, l, ...
      F_sr_i, F_sr_j, i-1, j-1);
    
    dist = sum((F_sr(:) - F_q(:)).^2);
    if dist < min_dist
      min_dist = dist;
      best_coh_i = max(min(ii, h), 1);
      best_coh_j = max(min(ii, w), 1);
    end
    
  end
end



end

