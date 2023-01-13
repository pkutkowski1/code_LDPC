clear
close all 
clc 

load('codee') 
tab = zeros(6,length(ber));

semilogy(EbN0dB,ber) 
hold on 

for i=1:5 
    load('codee_6_3_nb_'+string(i)+'.mat')
    
    semilogy(EbN0dB, ber)
    hold on 
end 


grid on 