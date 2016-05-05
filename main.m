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
A = double(imread('images/newflower-src.jpg'));
A_prime = double(imread('images/newflower-blur.jpg'));
B = double(imread('toy-newshore-src.jpg'));

A = imresize(A, 0.1);
A_prime = imresize(A_prime, 0.1);
B = imresize(B, 0.1);

% Make image analogy
B_prime = create_image_analogy(A, A_prime, B);
