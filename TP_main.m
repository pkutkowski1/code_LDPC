clear ; 
close all ; 
clc ;

addpath('src/')
addpath('lib/matlab-tanner-graphs/')

N = 6; 
K = 3;
R = 1; 
M =2 ; 



%% Construction du modulateur
mod_psk = comm.PSKModulator(...
    'ModulationOrder', M, ... % BPSK
    'PhaseOffset'    , 0, ...
    'SymbolMapping'  , 'Gray',...
    'BitInput'       , true);


demod_psk = comm.PSKDemodulator(...
    'ModulationOrder', M, ...
    'PhaseOffset'    , 0, ...
    'SymbolMapping'  , 'Gray',...
    'BitOutput'      , true,...
    'DecisionMethod' , 'Log-likelihood ratio');

%% BER 


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
%% AGWN
awgn_channel = comm.AWGNChannel(...
    'NoiseMethod', 'Signal to noise ratio (Es/No)',...
    'EsNo',EsN0dB(5),...
    'SignalPower',1);

%% LDPC

[H] = alist2sparse('alist/DEBUG_6_3.alist');

[h, g] = ldpc_h2g(H); 


%% Emmeteur 
b = randi([0,1],K,1);


% encodage 
sequence_e   = transpose(b)*g;  
sequence_e2         = encode(b, 6, 3, 'linear', g);

% modulation BPSK 
x      = step(mod_psk,sequence_e2);


% Ajout de la contribution du canal 
sigma2  = 1/(2*EsN0(1)); 
n       = sqrt(sigma2)*randn(size(x));
n       = x + n; 


% Démodulation QPSK 
Lc_1      = double(n < 0);

% Log de vraisemblance 
Lc        = 2*n/sigma2 ; 

% Décodage de canal 
sequence_r   = BP_algorithm(H, Lc, sigma2); 

% Décision 
rec_b   = double(sequence_r(1:N) < 0);







