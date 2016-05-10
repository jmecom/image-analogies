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

% Neightborhood size and num features
N_BIG = 5;
N_SMALL = 3;
NUM_FEATURES = 1;
NNF = N_BIG * N_BIG * NUM_FEATURES;
nnf = N_SMALL * N_SMALL * NUM_FEATURES;

kappa = 0.5;

G_big = fspecial('Gaussian', [N_BIG N_BIG]);
G_small = fspecial('Gaussian', [N_SMALL N_SMALL]);

% Read images

% % Blur
A = imread('images/newflower-src.jpg');
A_prime = imread('images/newflower-blur.jpg');
B = imread('toy-newshore-src.jpg');

% % Blur2
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
shrink_factor = 0.3;
A = imresize(A, shrink_factor);
A_prime = imresize(A_prime, shrink_factor);
B = imresize(B, shrink_factor);

% Make image analogy
B_prime = create_image_analogy(A, A_prime, B);
