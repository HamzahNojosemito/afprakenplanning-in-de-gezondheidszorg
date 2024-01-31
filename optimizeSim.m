close all
clear
clc

% In deze code zoeken we de optimale x-waarden (tussenaankomsttijden)
% De doelfunctiewaarde wordt geschat m.b.v. een simulatie gebaseerde 
% matlab-functie 'risk_sim' die geschreven is aan de hand van Kuiper (2016)
% Details op: https://pure.uva.nl/ws/files/2776103/174963_AlexKuiper_Thesis_complete.pdf

% ////////////////////////////////GEBRUIKERSINPUT////////////////////////////////
% Kies de inputwaarden
n = 11; % aantal patienten
w = 0.5; % gewichtsvariabele
sims = 1000000; % aantal simulaties per iteratie

B = zeros(sims, n); % maak alvast een matrix voor het opslaan van de
                    % bedieningsduren

% Kies een kansverdeling voor de bedieningsduren
% en kies de parameterwaarden van de verdeling
% die niet zullen veranderen voor alle iteraties in het optimalisatieproces

% Bedieningsduren met exponentiele verdeling
lambda = 3;
m_service = 1/lambda; % gemiddelde bedieningsduur
for i = 1:sims
    B(i,:) = exprnd(m_service, 1, n);
end

% % Bedieningsduren met gamma-verdeling
% k = 9;
% theta = 0.5;
% m_service = k*theta; % gemiddelde bedieningsduur
% for i = 1:sims
%     B(i,:) = gamrnd(k, theta, 1, n);
% end

% % Bedieningsduren met uniforme verdeling
% lwr = 0.5;
% upr = 7.5;
% m_service = (lwr+upr)/2; % gemiddelde bedieningsduur
% for i = 1:sims
%     B(i,:) = unifrnd(lwr, upr, 1, n);
% end

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




