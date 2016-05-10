global N_BIG;
global N_SMALL;
global NUM_FEATURES;
global NNF;
global nnf;
global A;
global B;
global kappa;
global G_big;
global G_small;
global end_idx;

% Neightborhood size and num features
N_BIG = 5;
N_SMALL = 3;
NUM_FEATURES = 1;
NNF = N_BIG * N_BIG * NUM_FEATURES;
nnf = N_SMALL * N_SMALL * NUM_FEATURES;
% end_idx = 12;
end_idx = sub2ind([N_BIG N_BIG], 2, 3);
% end_idx = sub2ind([N_BIG N_BIG], 2, 2);

kappa = 0;

G_big = fspecial('Gaussian', [N_BIG N_BIG]);

%G_big = (G_big + ones(5))/2;

G_small = fspecial('Gaussian', [N_SMALL N_SMALL]);

% Read images

% Texture transfer
% A = imread('transfer2_A1.jpg');
% A_prime = imread('transfer2_A2.jpg');
% B = imread('transfer2_B1.jpg');

% Texture synthesis
% tmp = imresize(imread('images/japanese-wallpaper.jpg'), .5);
% A = zeros(size(tmp));
% A_prime = tmp;
% B = zeros(125,125,3);

% Painting
% A = imread('images/rhone-src.jpg');
% A_prime = imread('images/rhone.jpg');
% B = imread('jakarta.jpg');

% Blur
A = imread('images/newflower-src.jpg');
A_prime = imread('images/newflower-blur.jpg');
B = imread('toy-newshore-src.jpg');

% Blur2
% A = imread('images/blurA1.jpg');
% A_prime = imread('images/blurA2.jpg');
% B = imread('images/blurB1.jpg');

% Identity Test
% A = imread('images/IdentityA.jpg');
% A_prime = imread('images/IdentityA.jpg');
% B = imread('IdentityB.jpg');

% %% Emboss Test
% A = imread('images/rose-src.jpg');
% A_prime = imread('images/rose-emboss.jpg');
% B = imread('dandilion-src.jpg');

% TODO: Remove this -- it's just faster for testing.
A_scale = 0.1;
B_scale = 0.1;
A = imresize(A, A_scale);
A_prime = imresize(A_prime, A_scale);
B = imresize(B, B_scale);

% Make image analogy
B_prime = create_image_analogy(A, A_prime, B);
