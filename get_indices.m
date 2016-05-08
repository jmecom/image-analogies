function [ start_i, end_i, start_j, end_j, ...
  pad_top, pad_bot, pad_left, pad_right] = get_indices( i, j, N, h, w )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

border_big = floor(N/2);

i_top = i-border_big;
pad_top = 1;
if i_top < 1
  start_i = 1;
  pad_top = 2-i_top;
else
  start_i = i_top;
end

i_bot = i+border_big;
pad_bot = N;
if i_bot > h
  pad_bot = N-(i_bot-h);
  end_i = h;
else
  end_i = i_bot;
end


j_left = j - border_big;
pad_left = 1;
if j_left < 1
  start_j = 1;
  pad_left = 2-j_left;
else
  start_j = j_left;
end

j_right = j + border_big;
pad_right = N;
if j_right > w
  end_j = w;
  pad_right = N-(j_right-w);
else
  end_j = j_right;
end

end

