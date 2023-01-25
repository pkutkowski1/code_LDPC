clear
clc
dbstop if error;
%% Parametres
% -------------------------------------------------------------------------
addpath('src')
simulation_name = '6310';
[H] = alist2sparse('./alist/6_3.alist');
nb_it           = 10;

R = 1; % Rendement de la communication

pqt_par_trame = 1; % Nombre de paquets par trame
bit_par_pqt   = 3;% Nombre de bits par paquet
K = pqt_par_trame*bit_par_pqt; % Nombre de bits de message par trame
N = K/R; % Nombre de bits codés par trame (codée)

M = 2; % Modulation BPSK <=> 2 symboles
phi0 = 0; % Offset de phase our la BPSK

EbN0dB_min  = -2; % Minimum de EbN0
EbN0dB_max  =  6; % Maximum de EbN0
EbN0dB_step =  1;% Pas de EbN0

nbr_erreur  = 100;  % Nombre d'erreurs à observer avant de calculer un BER
nbr_bit_max = 100e6;% Nombre de bits max à simuler
ber_min     = 1e-6; % BER min

EbN0dB = EbN0dB_min:EbN0dB_step:EbN0dB_max;     % Points de EbN0 en dB à simuler
EbN0   = 10.^(EbN0dB/10);% Points de EbN0 à simuler
EsN0   = R*log2(M)*EbN0; % Points de EsN0
EsN0dB = 10*log10(EsN0); % Points de EsN0 en dB à simuler

% -------------------------------------------------------------------------

%% Construction du modulateur
mod_psk = comm.PSKModulator(...
    'ModulationOrder', M, ... % BPSK
    'PhaseOffset'    , phi0, ...
    'SymbolMapping'  , 'Gray',...
    'BitInput'       , true);

%% Construction du demodulateur
demod_psk = comm.PSKDemodulator(...
    'ModulationOrder', M, ...
    'PhaseOffset'    , phi0, ...
    'SymbolMapping'  , 'Gray',...
    'BitOutput'      , true,...
    'DecisionMethod' , 'Log-likelihood ratio');

%% Construction du canal AWGN
awgn_channel = comm.AWGNChannel(...
    'NoiseMethod', 'Signal to noise ratio (Es/No)',...
    'EsNo',EsN0dB(1),...
    'SignalPower',1);

%% Construction de l'objet évaluant le TEB
stat_erreur = comm.ErrorRate(); % Calcul du nombre d'erreur et du BER

%% Initialisation des vecteurs de résultats
ber = zeros(1,length(EbN0dB));
Pe = qfunc(sqrt(2*EbN0));

%% Préparation de l'affichage
figure(1)
h_ber = semilogy(EbN0dB,ber,'XDataSource','EbN0dB', 'YDataSource','ber');
hold all
ylim([1e-6 1])
grid on
xlabel('$\frac{E_b}{N_0}$ en dB','Interpreter', 'latex', 'FontSize',14)
ylabel('TEB','Interpreter', 'latex', 'FontSize',14)

%% Préparation de l'affichage en console
msg_format = '|   %7.2f  |   %9d   |  %9d | %2.2e |  %8.2f kO/s |   %8.2f kO/s |   %8.2f s |\n';

fprintf(      '|------------|---------------|------------|----------|----------------|-----------------|--------------|\n')
msg_header =  '|  Eb/N0 dB  |    Bit nbr    |  Bit err   |   TEB    |    Debit Tx    |     Debit Rx    | Tps restant  |\n';
fprintf(msg_header);
fprintf(      '|------------|---------------|------------|----------|----------------|-----------------|--------------|\n')

%% Matrice encodage 



[h, g] = ldpc_h2g(H); 

H                    = full(h);

[nb_ligneH, nb_colH] = size(H); 
[nb_entree, nb_bits] = size(g); 
[row_H,col_H]        = find(H);
nb_ones_H            = length(row_H);




%rowH,colH,nb_ones_H, Lc, nb_colH,nb_ligneH, nb_bits)

%% Simulation
for i_snr = 1:length(EbN0dB)
    reverseStr = ''; % Pour affichage en console
    awgn_channel.EsNo = EsN0dB(i_snr);% Mise a jour du EbN0 pour le canal
    demod_psk.Variance = awgn_channel.Variance;
    
    sigma2 = 1/(2*EbN0(i_snr));
    stat_erreur.reset; % reset du compteur d'erreur
    err_stat    = [0;0;0]; % vecteur résultat de stat_erreur
        
    n_frame = 0;
    T_rx = 0;
    T_tx = 0;
    general_tic = tic;
    while (err_stat(2) < nbr_erreur && err_stat(3) < nbr_bit_max)
        n_frame = n_frame + 1;
        
        %% Emetteur
        tx_tic = tic;                 % Mesure du débit d'encodage
        b    = randi([0,1],K,1);    % Génération du message aléatoire
        c    = encode(b, nb_colH, nb_ligneH, 'linear', g); 
        x      = step(mod_psk,  c); % Modulation BPSK % Modulation BPSK
        T_tx   = T_tx+toc(tx_tic);    % Mesure du débit d'encodage
        
        %% Canal
        y     = step(awgn_channel,x); % Ajout d'un bruit gaussien
        
        %% Recepteur
        rx_tic = tic;                  % Mesure du débit de décodage
        %Lc      = 2*y/sigma2 ;  % Démodulation (retourne des LLRs)
        Lc      = step(demod_psk,y);
        B = BP_algorithm2(row_H,col_H,nb_ones_H, Lc, nb_colH,nb_ligneH, nb_bits, nb_it,H); 
        rec_b1 = double(B < 0); % Décision
        
        % rec_b = double(Lc(1:K) < 0); % Décision
        
        T_rx    = T_rx + toc(rx_tic);  % Mesure du débit de décodage
        
        err_stat   = step(stat_erreur, c, transpose(rec_b1)); % Comptage des erreurs binaires
        
        %% Affichage du résultat
        if mod(n_frame,100) == 1
            msg = sprintf(msg_format,...
                EbN0dB(i_snr),         ... % EbN0 en dB
                err_stat(3),           ... % Nombre de bits envoyés
                err_stat(2),           ... % Nombre d'erreurs observées
                err_stat(1),           ... % BER
                err_stat(3)/8/T_tx/1e3,... % Débit d'encodage
                err_stat(3)/8/T_rx/1e3,... % Débit de décodage
                toc(general_tic)*(nbr_erreur - min(err_stat(2),nbr_erreur))/(min(err_stat(2),nbr_erreur))); % Temps restant
            fprintf(reverseStr);
            msg_sz =  fprintf(msg);
            reverseStr = repmat(sprintf('\b'), 1, msg_sz);
        end
        
    end
    
    msg = sprintf(msg_format,...
        EbN0dB(i_snr),         ... % EbN0 en dB
        err_stat(3),           ... % Nombre de bits envoyés
        err_stat(2),           ... % Nombre d'erreurs observées
        err_stat(1),           ... % BER
        err_stat(3)/8/T_tx/1e3,... % Débit d'encodage
        err_stat(3)/8/T_rx/1e3,... % Débit de décodage
        0); % Temps restant
    fprintf(reverseStr);
    msg_sz =  fprintf(msg);
    reverseStr = repmat(sprintf('\b'), 1, msg_sz);
    
    ber(i_snr) = err_stat(1);
    refreshdata(h_ber);
    drawnow limitrate
    
    if err_stat(1) < ber_min
        break
    end
    
end
fprintf('|------------|---------------|------------|----------|----------------|-----------------|--------------|\n')

%%
figure(1)
semilogy(EbN0dB,ber);
hold all
xlim([0 10])
ylim([1e-6 1])
grid on
xlabel('$\frac{E_b}{N_0}$ en dB','Interpreter', 'latex', 'FontSize',14)
ylabel('TEB','Interpreter', 'latex', 'FontSize',14)


save(simulation_name,'EbN0dB','ber')