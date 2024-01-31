close all
clear
clc

% Met deze code tonen we de driedimensionale (n=3) grafiek
% van de doelfunctie 'risk_sim'

% De doelfunctie 'risk_sim' is geschreven aan de hand van Kuiper (2016)
% Details op: https://pure.uva.nl/ws/files/2776103/174963_AlexKuiper_Thesis_complete.pdf

% ////////////////////////////////GEBRUIKERSINPUT////////////////////////////////
% Kies de inputwaarden
n = 3; % aantal patienten
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

% Maak een 'grid' van waarden voor de twee elementen van x
x1_waarden = linspace(0, 1, 100);
x2_waarden = linspace(0, 1, 100);
[x1, x2] = meshgrid(x1_waarden, x2_waarden);

% Evalueer de doelfunctie voor elke combinatie van x1 en x2
r_waarden = zeros(size(x1));
for i = 1:numel(x1)
    r_waarden(i) = risk_sim([x1(i), x2(i)], n, w, sims, B);
end

% 'Reshape' het resultaat voor het maken van een grafiek
r_waarden = reshape(r_waarden, size(x1));

% Maak een 3D plot
figure;
surf(x1, x2, r_waarden);
xlabel('$x_1$', 'Interpreter', 'latex');
ylabel('$x_2$', 'Interpreter', 'latex');
zlabel('$s(\vec{x})$', 'Interpreter', 'latex');

% Voeg een kleurenbalk toe ter referentie
colorbar;
