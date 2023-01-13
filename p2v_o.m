function [P_p2v] = p2v_o(P_v2p,nb_ones, rowH,colH, nb_colH,nb_ligneH) 
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
P_p2v = zeros(nb_ligneH, nb_colH); 

for i = 1:nb_ones     %boucle sur 1 présents dans H 
    P_p2v(rowH(i),colH(i)) = 1; 
    
    index = colH(find(rowH==rowH(i))); 
        for l = 1:length(index)  
             if(index(l)~=colH(i))
                P_p2v(rowH(i),colH(i)) = P_p2v(rowH(i),colH(i))*tanh(P_v2p(rowH(i),index(l))/2); 
             end 
        end 
            P_p2v(rowH(i),colH(i)) = 2*atanh(P_p2v(rowH(i),colH(i))); 
             
end
        
        
 
 
end

