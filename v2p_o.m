function [P_v2p] = v2p_o(P_p2v,Y0,nb_ones_H,rowH,colH, nb_colH,nb_ligneH,H)

P_v2p = zeros(nb_ligneH, nb_colH); 

% P_v2p = repmat(Y0,nb_ligneH,1);
% 
% fun = @(j) (Y0 + sum(P_p2v(1:end~=j,:))).*H(j,:);
% 
% for i=1:nb_ligneH
%     P_v2p(i,:) = fun(i);
% end


for i = 1: nb_ones_H 
    index = rowH(find(colH==colH(i)));
    mask = ones(nb_ligneH, 1); 
    mask(index==rowH(i)) = 0 ;     
    P_v2p(rowH(i),colH(i)) = Y0(colH(i)) + sum(P_p2v(:,colH(i)).*mask); 
    
end 

P_v2p(P_v2p>100)=100;
P_v2p(P_v2p<-100)=-100;
end 

