% Read images
A = double(imread('images/newflower-src.jpg'));
A_prime = double(imread('images/newflower-blur.jpg'));
B = double(imread('toy-newshore-src.jpg'));

B_prime = create_image_analogy(A, A_prime, B);

