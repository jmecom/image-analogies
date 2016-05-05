global N_BIG;
global N_SMALL;
global NUM_FEATURES;
global NNF;
global nnf;
global A;
global B;

% Neightborhood size and num features
N_BIG = 5;
N_SMALL = 3;
NUM_FEATURES = 3;
NNF = N_BIG * N_BIG * NUM_FEATURES;
nnf = N_SMALL * N_SMALL * NUM_FEATURES;

% Read images

% Blur
% A = double(imread('images/newflower-src.jpg'));
% A_prime = double(imread('images/newflower-blur.jpg'));
% B = double(imread('toy-newshore-src.jpg'));

A = double(imread('images/rose-src.jpg'));
A_prime = double(imread('images/rose-emboss.jpg'));
B = double(imread('dandilion-src.jpg'));

% TODO: Remove this -- it's just faster for testing.
shrink_factor = 0.1;
A = imresize(A, shrink_factor);
A_prime = imresize(A_prime, shrink_factor);
B = imresize(B, shrink_factor);

% Make image analogy
% imshow(uint8(B));
B_prime = create_image_analogy(A, A_prime, B);
