function [P_v2p] = v2p(P_p2v, Y0, H)

[size_c, size_l] = size(P_p2v); 
P_v2p = zeros(size_c, size_l); 
H = full(H); 
for i = 1: size_c
    for k = 1: size_l 
        if (H(i,k) == 1)
            P_v2p(i,k) = Y0(k); % Ajout de la contribution du canal 
            for l = 1:size_c 
                 if(l~=i )
                    P_v2p(i,k) = P_v2p(i,k) + P_p2v(l,k); 
                 end 

             end 
        end 
        
    end 
    
end 
end 






