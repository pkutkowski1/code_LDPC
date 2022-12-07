clear ; 
close all ; 
clc ;

addpath('src/')
addpath('lib/matlab-tanner-graphs/')

N = 6; 
K = 3;
R = 1; 
M =2 ; 


EbN0dB_min  = -2; % Minimum de EbN0
EbN0dB_max  = 10; % Maximum de EbN0
EbN0dB_step = 1;% Pas de EbN0

nbr_erreur  = 100;  % Nombre d'erreurs à observer avant de calculer un BER
nbr_bit_max = 100e6;% Nombre de bits max à simuler
ber_min     = 1e-6; % BER min

EbN0dB = EbN0dB_min:EbN0dB_step:EbN0dB_max;     % Points de EbN0 en dB à simuler
EbN0   = 10.^(EbN0dB/10);% Points de EbN0 à simuler
EsN0   = R*log2(M)*EbN0; % Points de EsN0
EsN0dB = 10*log10(EsN0); % Points de EsN0 en dB à simuler

awgn_channel = comm.AWGNChannel(...
    'NoiseMethod', 'Signal to noise ratio (Es/No)',...
    'EsNo',EsN0dB(1),...
    'SignalPower',1);


[H] = alist2sparse('alist/DEBUG_6_3.alist');

[h, g] = ldpc_h2g(H); 
b = randi([0,1],K,1);

c = transpose(b)*g;  %encode the bitstream 

Y0     = step(awgn_channel,c);

sigma2 = awgn_channel.Variance; 

B = BP_algorithm(H, Y0, sigma2); 



tn = tanner_graph(H);

figure, 
plot(tn) 





