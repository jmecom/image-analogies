# image-analogies

![](http://jmecom.github.io/images/image-analogies/header.PNG)

#### [Full writeup here.](http://jmecom.github.io/projects/computational-photography/image-analogies/)

This repository contains a MATLAB implementation of Image Analogies by Hertzmann, et al. 
The paper's website (which includes more results) can be viewed [here](http://mrl.nyu.edu/projects/image-analogies/).

The image analogies paper develops a framework which can create new images from a single training example. 
This is done through the idea of an image analogy: take an image A and its transformation A’, and provide 
any image B to produce an output B’ that is analogous to A’. Or, more succinctly: A : A’ :: B : B’. 
Hertzmann’s algorithm attempts to learn complex, non-linear transformations between A and A’, allowing 
them to be applied to any other image. This provides a much more powerful and intuitive model than manually 
selecting filters from a list.
