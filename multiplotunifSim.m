close all
clear
clc

% Met deze code zoeken we de optimale x-waarden (tussenaankomsttijden)
% voor verschillende a en b-waarden (parameterwaarden voor de
% uniform verdeelde bedieningsduren)
% De doelfunctiewaarde wordt geschat m.b.v. een simulatie gebaseerde 
% matlab-functie 'risk_sim' die geschreven is aan de hand van Kuiper (2016)
% Details op: https://pure.uva.nl/ws/files/2776103/174963_AlexKuiper_Thesis_complete.pdf

a_b_matrix = [0.5, 1, 1.5, 1.5, 2, 2.5, 2.5, 3, 3.5; 3.5, 3, 2.5, 4.5, 4, 3.5, 5.5, 5, 4.5]; % matrix
                                           % met a-waarden in de eerste rij en b-waarden in de tweede
for j = 1:numel(a_b_matrix(1,:))
    % ////////////////////////////////GEBRUIKERSINPUT////////////////////////////////
    % Kies de inputwaarden
    n = 11; % aantal patienten
    w = 0.5; % gewichtsvariabele
    sims = 1000000; % aantal simulaties per iteratie
    
    B = zeros(sims, n); % maak alvast een matrix voor het opslaan van de
                        % bedieningsduren

    % Bedieningsduren met uniforme verdeling
    B = zeros(sims, n);
    lwr = a_b_matrix(1,j);
    upr = a_b_matrix(2,j);
    m_service = (lwr+upr)/2; % gemiddelde bedieningsduur
    for i = 1:sims
        B(i,:) = unifrnd(lwr, upr, 1, n);
    end
    
    % //////////////////////////////////////////////////////////////////////////////


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
string_array = cell(size(a_b_matrix(1,:)));
for i = 1:numel(a_b_matrix(1,:))
    string_array{i} = ['a=' rats(a_b_matrix(1,i)) ', b=' rats(a_b_matrix(2,i))];
    string_array{i} = strrep(string_array{i}, ' ', '');
end
legend(string_array,'Location','best','Orientation','vertical')
lgd = legend;
lgd.NumColumns = 3;
