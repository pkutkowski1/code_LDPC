function [P_p2v] = p2v(P_v2p, H)

[size_c, size_l] = size(P_v2p); 
P_p2v = zeros(size_c, size_l); 

H = full(H);
for i = 1:size_c     %boucle sur les colones 
    for k = 1:size_l %boucle sur les lignes 
        if (H(i,k) == 1) 
            P_p2v(i,k) = 1; 
            for l = 1:size_l 
                 if(l~=k && H(i,l)==1 )
                    P_p2v(i,k) = P_p2v(i,k)*tanh(P_v2p(i,l)/2); 
                 end 
            end 
            P_p2v(i,k) = 2*atanh(P_p2v(i,k)); 
             
        end
        
        
    end 
end 
    
end 

