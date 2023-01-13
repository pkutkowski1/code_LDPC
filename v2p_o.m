function [P_v2p] = v2p_o(P_p2v,Y0,nb_ones_H,rowH,colH, nb_colH,nb_ligneH)

P_v2p = zeros(nb_ligneH, nb_colH); 

for i = 1: nb_ones_H 
    mask = ones(nb_ligneH, 1); 
    mask(rowH(i)) = 0 ;     
    P_v2p(rowH(i),colH(i)) = Y0(colH(i)) + sum(P_p2v(:,colH(i)).*mask); 
end 
end 

