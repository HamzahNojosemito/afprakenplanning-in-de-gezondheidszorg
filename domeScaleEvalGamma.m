clear
clc

% Met deze code onderzoeken we de invloed van de variantie,
% bij constante verwachting, op de koepelvorm van 
% de optimale x-waarden (tussenaankomsttijden)
% De doelfunctiewaarde wordt geschat m.b.v. een simulatie gebaseerde 
% matlab-functie 'risk_sim' die geschreven is aan de hand van Kuiper (2016)
% Details op: https://pure.uva.nl/ws/files/2776103/174963_AlexKuiper_Thesis_complete.pdf

% ////////////////////////////////GEBRUIKERSINPUT////////////////////////////////
% Kies de inputwaarden
n = 5; % aantal patienten
w = 0.5; % gewichtsvariabele
sims = 1000000; % aantal simulaties per iteratie

inverse_scale_array = [sort(1./(1:10), 'ascend'), 2:10]; % een reeks met omgekeerde schaalwaarden
                                                         % (omgekeerde theta-waarden)
tests = length(inverse_scale_array); % aantal toetsen voor het vergelijken 
                                     % van de koepelschaal en variantie
dome_scale_array = zeros(1, tests); % reeks voor het opslaan van de koepelschaal
variance_array = zeros(1, tests); % reeks voor het opslaan van de variantie
for a = 1:tests
    B = zeros(sims, n);
    
    % Gebruik de gamma-verdeling voor de bedieningsduren
    k = inverse_scale_array(a);
    theta = 1/inverse_scale_array(a);
    m_service = k*theta;
    for i = 1:sims
        B(i,:) = gamrnd(k, theta, 1, n);
    end
    
    % //////////////////////////////////////////////////////////////////////////
    
    
    % Definieer de doelfunctie die geoptimaliseerd moet worden
    f = @(x)risk_sim(x, n, w, sims, B);
    
    % Optimaliseer de doelfunctie m.b.v. het SPSA algoritme
    [optimal_x, f_val] = fminSPSA(f, n-1, m_service);
    
    % Definieer de koepelschaal
    x = max(optimal_x) - min(optimal_x);
    y = max(optimal_x);
    dome_scale = x/y;

    % Definieer de variantie
    variance = k*(theta^2);
    
    % Voeg de waarde van de koepelschaal en variantie toe aan aparte reeksen
    dome_scale_array(a) = dome_scale;
    variance_array(a) = variance;
end

% Plotten
plot(variance_array, dome_scale_array, 'o-');
xlabel('Variantie');
ylabel('Koepel schaal');
title('Variantie vs. koepel schaal');