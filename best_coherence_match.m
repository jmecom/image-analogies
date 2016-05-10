function [ best_coh_i, best_coh_j] = best_coherence_match( A_pyramid, A_prime_pyramid, ...
  B_pyramid, B_prime_pyramid, s_pyramid, l, L, i, j)
%BEST_COHERENCE_MATCH
% (i,j) are q in the paper

global N_BIG;

% % imshow pyramids
% if l ~= L
%   subplot(1, 2, 1);
%   imshow(A_pyramid{l});
%   subplot(1, 2, 2);
%   imshow(A_pyramid{l+1})
% end

[A_h, A_w, ~] = size(A_pyramid{l});
border_big = floor(N_BIG/2);

F_q = concat_feature(B_pyramid, B_prime_pyramid, ...
  l, i, j, L);
%
% % Zero elements in F_q
% F_q_zeros = (F_q == 0);

min_dist = inf;
r_star_i = -1;
r_star_j = -1;

% Loop over neighborhood
done = false;
for ii = i-border_big:i+border_big
  for jj = j-border_big:j+border_big
    
    % Done, (i,j) is the first un-synthesized pixel
    if ii == i && jj == j
      done = true;
      break
    end
    
%     fprintf('~~~~~~~~~~~~~~~~~~\n')
    
    % Pixel that the neighbor was matched to
    s_i = s_pyramid{l}(ii,jj,1);
    s_j = s_pyramid{l}(ii,jj,2);
    
%     fprintf('q: (%d, %d), q-r: (%d, %d)\n', i, j, i-ii, j-jj);
%     fprintf('r: (%d, %d)\n', ii, jj);
%     fprintf('s(r): (%d, %d)\n', s_i, s_j);
    
    % A coherent pixel match for q
    % A neighbor to our neighbor's match
    % should be a good match for us!
    F_sr_i = s_i + (i - ii); % this is a problem for when s is not yet
    F_sr_j = s_j + (j - jj); % set, we solve this by just doing
    % approx match only for first 3 rows.
    
    if F_sr_i > A_h || F_sr_i < 1 || ...
        F_sr_j > A_w || F_sr_j < 1
%       fprintf('Caught OOB at (%d, %d)\n', F_sr_i, F_sr_j);
      continue
    end
    
    %     F_sr_i
    %     F_sr_j
%     fprintf('s(r) + (q-r): (%d, %d)\n', F_sr_i, F_sr_j);
    F_sr = concat_feature(A_pyramid, A_prime_pyramid, l, ...
      F_sr_i, F_sr_j, L);
    
%     fprintf('sum(F_sr(:)) %d \n', sum(F_sr(:)));
% %     fprintf('size(F_sr): %d, size(F_q): %d\n', nnz(F_sr), nnz(F_q));
    
    dist = sum((F_sr(:) - F_q(:)).^2); % * (nnz(F_sr));
    
    if dist < min_dist
      min_dist = dist;
      r_star_i = ii;
      r_star_j = jj;
      best_coh_i = F_sr_i;
      best_coh_j = F_sr_j;
    end
  end
  
  if done
    break
  end
  
end

% Nothing was set!
if r_star_i == -1 || r_star_j == -1
  best_coh_i = -1;
  best_coh_j = -1;
  return
end


% s_rstar_i = s_pyramid{l}(r_star_i,r_star_j,1);
% s_rstar_j = s_pyramid{l}(r_star_i,r_star_j,2);

% fprintf('===\n');
% fprintf('r*: (%d, %d), q-r*: (%d, %d)\n', ...
%   r_star_i, r_star_j, (i - r_star_i), (j - r_star_j));
% fprintf('s(r*): (%d, %d)\n', s_rstar_i, s_rstar_j);
% fprintf('p: (%d, %d)\n', s_rstar_i + (i - r_star_i), ...
%   s_rstar_j + (j - r_star_j));
% r_star_i
% r_star_j
% (i - r_star_i)
% (j - r_star_j)
% s_rstar_i
% s_rstar_j

% best_coh_i = s_rstar_i + (i - r_star_i);
% best_coh_j = s_rstar_j + (j - r_star_j);

end

