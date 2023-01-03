function [O] = BP_algorithm(H, Y0,nb_it)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
O     = zeros(1,length(Y0)); 
P_v2p = zeros(3,6); 
P_p2v = zeros(3,6); 

% rapport de vraisemblance du canal
for i = nb_it
   P_v2p = v2p(P_p2v, Y0, H); 
   P_p2v = p2v(P_v2p, H);
   
end

[dim_c,dim_l] = size(P_p2v); 

for i=1:dim_l 
    O(i) = sum(P_p2v(:,i)) + Y0(i) ;     
end





end

