close all
clear
clc

% Met deze code tonen we de tweedimensionale (n=2) grafiek
% van de doelfunctie 'risk_sim'

% De doelfunctie 'risk_sim' is geschreven aan de hand van Kuiper (2016)
% Details op: https://pure.uva.nl/ws/files/2776103/174963_AlexKuiper_Thesis_complete.pdf


% ////////////////////////////////GEBRUIKERSINPUT////////////////////////////////
% Kies de inputwaarden
n = 2; % aantal patienten
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


% Maak een 2D plot
fplot(@(x) risk_sim(x, n, w, sims, B), [0,1])
xlabel('$x_1$', 'Interpreter', 'latex');
ylabel('$s(\vec{x})$', 'Interpreter', 'latex');