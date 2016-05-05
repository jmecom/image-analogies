function [best_app_i, best_app_j] = best_approximate_match(A_features, ...
  B_features, l, i, j)
%BEST_APPROXIMATE_MATCH ...

global N_BIG;
global A;
global B;

% Convert (i,j) back...
i = i - floor(N_BIG/2);
j = j - floor(N_BIG/2);

% Transpose since our ANN library wants d*N but it's N*d right now.
A_features{l} = A_features{l}';

% Load up our ANN library
% https://github.com/jefferislab/MatlabSupport/tree/master/ann_wrapper
anno = ann(A_features{l});

query_pnt = B_features{l}(sub2ind(size(B(:,:,1)), i, j), :);
query_pnt = query_pnt';

% This returns the index into A_features that gives the best
% neighborhood for the given query_pnt. 
[idx, ~] = ksearch(anno, query_pnt, 1, 1.0);

% Now we need to find the (i,j)'th pixel that this neighborhood 
% corresponds with. Due to stupid indexing, we have to do some
% flipping of heights and widths here.
[A_h, A_w, ~] = size(A);
[best_app_j, best_app_i] = ind2sub([A_w, A_h], idx); % flip???

% Free memory
anno = close(anno);

end

