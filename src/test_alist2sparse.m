clear 
close all
clc


[H] = alist2sparse('../alist/CCSDS_64_128.alist');
[h, g] = ldpc_h2g(H);
g