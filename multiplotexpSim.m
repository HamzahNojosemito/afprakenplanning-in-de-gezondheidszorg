close all
clear
clc

% Met deze code zoeken we de optimale x-waarden (tussenaankomsttijden)
% voor verschillende lambda-waarden (parameterwaarde voor de
% exponentieel verdeelde bedieningsduren)
% De doelfunctiewaarde wordt geschat m.b.v. een simulatie gebaseerde 
% matlab-functie 'risk_sim' die geschreven is aan de hand van Kuiper (2016)
% Details op: https://pure.uva.nl/ws/files/2776103/174963_AlexKuiper_Thesis_complete.pdf

lambda_array = 1:10; % reeks met waarden voor lambda
for lambda = lambda_array 
    % ////////////////////////////////GEBRUIKERSINPUT////////////////////////////////
    % Kies de inputwaarden
    n = 11; % aantal patienten
    w = 0.5; % gewichtsvariabele
    sims = 1000000; % aantal simulaties per iteratie
    
    B = zeros(sims, n); % maak alvast een matrix voor het opslaan van de
                        % bedieningsduren
    
    % Bedieningsduren met exponentiele verdeling
    m_service = 1/lambda; % gemiddelde bedieningsduur
    for i = 1:sims
        B(i,:) = exprnd(m_service, 1, n);
    end

    % //////////////////////////////////////////////////////////////////////////
    
    
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
string_array = cell(size(lambda_array));
for i = 1:numel(lambda_array)
    string_array{i} = ['λ=' num2str(lambda_array(i))];
end
legend(string_array,'Location','best','Orientation','vertical')
lgd = legend;
lgd.NumColumns = 2;