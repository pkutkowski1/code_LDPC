function [R] = BP_algorithm(H, Y0, sigma)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
nb_it = 20; 
P_v2p = zeros(3,6); 
P_p2v = zeros(3,6); 

% rapport de vraisemblance du canal 
R = 2*(Y0./sigma) ; 

for i = nb_it
   P_v2p = v2p(P_p2v, R, H); 
   P_p2v = p2v(P_v2p, H);
   
end

[dim_c,dim_l] = size(P_p2v); 




end

