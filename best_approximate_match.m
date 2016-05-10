function [best_app_i, best_app_j] = best_approximate_match(A_features, ...
  A_pyramid, B_pyramid, B_features, l, i, j)
%BEST_APPROXIMATE_MATCH ...

global N_BIG;


% Transpose since our ANN library wants d*N but it's N*d right now.
A_features{l} = A_features{l}';

% Load up our ANN library
% https://github.com/jefferislab/MatlabSupport/tree/master/ann_wrapper
anno = ann(A_features{l});

query_pnt = B_features{l}(sub2ind(size(B_pyramid{l}(:,:,1)), i, j), :);
query_pnt = query_pnt';

% This returns the index into A_features that gives the best
% neighborhood for the given query_pnt. 
[idx, ~] = ksearch(anno, query_pnt, 1, 1.0);

% % Test: use brute force just to sanity-check ANN
% for ii=1:length(A_features{l})
% %   size(A_features{l}(:,ii))
% %   size(query_pnt(:))
%   dist = sum((A_features{l}(:,ii) - query_pnt(:)).^2);
%   if dist < min_so_far
%     min_idx = ii;
%     min_so_far = dist;
%   end
% end

% Now we need to find the (i,j)'th pixel that this neighborhood 
% corresponds with. Due to stupid indexing, we have to do some
% flipping of heights and widths here.
[A_h, A_w, ~] = size(A_pyramid{l});
[best_app_i, best_app_j] = ind2sub([A_h, A_w], idx); % flip???

% Free memory
anno = close(anno);

end

