close all
clear
clc

% Met deze code zoeken we de optimale x-waarden (tussenaankomsttijden)
% voor verschillende k en theta-waarden (parameterwaarden voor de
% gamma verdeelde bedieningsduren)
% De doelfunctiewaarde wordt geschat m.b.v. een simulatie gebaseerde 
% matlab-functie 'risk_sim' die geschreven is aan de hand van Kuiper (2016)
% Details op: https://pure.uva.nl/ws/files/2776103/174963_AlexKuiper_Thesis_complete.pdf

k_theta_matrix = [1, 1, 1, 5, 5, 5, 9, 9, 9; 1, 2, 3, 1/5, 2/5, 3/5, 1/9, 2/9, 1/3]; % matrix
                                % met k-waarden in de eerste rij en theta-waarden in de tweede
for j = 1:numel(k_theta_matrix(1,:))
    % ////////////////////////////////GEBRUIKERSINPUT////////////////////////////////
    % Kies de inputwaarden
    n = 11; % aantal patienten
    w = 0.5; % gewichtsvariabele
    sims = 1000000; % aantal simulaties per iteratie
    
    B = zeros(sims, n); % maak alvast een matrix voor het opslaan van de
                        % bedieningsduren

    % Bedieningsduren met gamma-verdeling
    k = k_theta_matrix(1,j);
    theta = k_theta_matrix(2,j);
    m_service = k*theta; % gemiddelde bedieningsduur
    for i = 1:sims
        B(i,:) = gamrnd(k, theta, 1, n);
    end
    
    % ///////////////////////////////////////////////////////////////////////////////


    % Definieer de doelfunctie die geoptimaliseerd moet worden
    f = @(x)risk_sim(x, n, w, sims, B);
    
    % Optimaliseer de doelfunctie m.b.v. het SPSA algoritme
    [optimal_x, f_val] = fminSPSA(f, n-1, m_service);
    
    % Maak een vector met alle i (= 1,2,...n)
    i = 1:length(optimal_x);
    
    % Plotten
    plot(i, optimal_x, 'o-');
    xlabel('$i$', 'Interpreter', 'latex');
    ylabel('$x_i$', 'Interpreter', 'latex');
    hold on
end
hold off

% Maak een legenda voor de grafiek
string_array = cell(size(k_theta_matrix(1,:)));
for i = 1:numel(k_theta_matrix(1,:))
    string_array{i} = ['k=' rats(k_theta_matrix(1,i)) ', θ=' rats(k_theta_matrix(2,i))];
    string_array{i} = strrep(string_array{i}, ' ', '');
end
legend(string_array,'Location','best','Orientation','vertical')
lgd = legend;
lgd.NumColumns = 3;
