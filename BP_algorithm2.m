function [O] = BP_algorithm2(rowH,colH,nb_ones_H, Lc, nb_colH,nb_ligneH, nb_bits, nb_it)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

O     = zeros(1,nb_colH); 
P_v2p = zeros(nb_ligneH,nb_colH); 
P_p2v = zeros(nb_ligneH,nb_colH); 

% rapport de vraisemblance du canal
for i = nb_it
   P_v2p = v2p_o(P_p2v,Lc,nb_ones_H,rowH,colH, nb_colH,nb_ligneH); 
   P_p2v = p2v_o(P_v2p, nb_ones_H, rowH,colH, nb_colH,nb_ligneH);
end

O = sum(P_p2v) + Lc';     


end

