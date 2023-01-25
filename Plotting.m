clear
close all
clc 
figure,
load('non_codee.mat')
semilogy(EbN0dB(1:9), ber(1:9), 'DisplayName','non codee')
hold on 
for i=1:5 
    load('63' + string(i)+ '.mat')
    semilogy(EbN0dB, ber, 'DisplayName','nb = ' + string(i))
    hold on
    
    
end

hold off 
grid on
xlabel('$\frac{E_b}{N_0}$ en dB','Interpreter', 'latex', 'FontSize',14)
ylabel('TEB','Interpreter', 'latex', 'FontSize',14)
legend show 


%% Plotting all codes 


load('CCSDS10.mat')
figure, 
semilogy(EbN0dB, ber, 'DisplayName','CCSDS')
hold on 
load('6310.mat')
semilogy(EbN0dB, ber, 'DisplayName','63')
load('MK10.mat')
semilogy(EbN0dB, ber, 'DisplayName','MAK-KAY')

hold off 
grid on
xlabel('$\frac{E_b}{N_0}$ en dB','Interpreter', 'latex', 'FontSize',14)
ylabel('TEB','Interpreter', 'latex', 'FontSize',14)
legend show 

