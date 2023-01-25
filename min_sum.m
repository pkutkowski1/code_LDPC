function [P_p2v] = min_sum(P_v2p,nb_ones, rowH,colH, nb_colH,nb_ligneH,H) 
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
P_p2v = zeros(nb_ligneH, nb_colH); 

% P_v2p_inf = P_v2p; % introduction des L_v->p
% P_v2p_inf(H==0)=Inf; % ne joue plus dans le produit
% 
% fun = @(x) 2*atanh(prod(tanh(x/2),2));
% 
% for i=1:nb_colH % mise a jour par colonne
%     v2p_i = P_v2p_inf(:,1:end~=i);
%     P_p2v(:,i) = fun(v2p_i);
% end

P_p2v = P_p2v .* H; % elimine les valeurs inutiles

for i = 1:nb_ones     %boucle sur 1 présents dans H 
    index = colH(find(rowH==rowH(i)));  
    index(index==colH(i)) = [];  
    % c_beliefs(j) = prod(tanh(v_beliefs(find(H(j,:)==1)))); 
    P_p2v(rowH(i),colH(i)) =  prod(sign(P_v2p(rowH(i),index)))*abs(min(P_v2p(rowH(i),index)));         
end

P_p2v(P_p2v>100)=100;
P_p2v(P_p2v<-100)=-100;
        
        
 
 
end

