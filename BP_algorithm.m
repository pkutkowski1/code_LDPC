function [R] = BP_algorithm(H, Y0, sigma,nb_it)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

P_v2p = zeros(3,6); 
P_p2v = zeros(3,6); 

% rapport de vraisemblance du canal 
R = Y0 ; 

for i = nb_it
   P_v2p = v2p(P_p2v, R, H); 
   P_p2v = p2v(P_v2p, H);
   
end




[dim_c,dim_l] = size(P_p2v); 

for i=1:dim_l 
    R(i) = sum(P_p2v(:,i));     
end
    


end

