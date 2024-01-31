close all
clear
clc

% Met deze code tonen we de driedimensionale (n=3) grafiek
% van de doelfunctie 'risk'

% De doelfunctie 'risk' is geschreven volgens Mendel (2006)
% Details op: http://www.math.tau.ac.il/~hassin/sharon_thesis.pdf

% //////////////////////////////GEBRUIKERSINPUT/////////////////////////////
% Kies de inputwaarden
n = 3; % aantal patienten
n0 = 1; % aantal patienten ingepland op t = 0
lambda = 3; % 1/lambda is de gemiddelde bedieningsduur (exponentieel)
p = 1; % kans dat de patienten komen opdagen
gamma = 0.5; % gewichtsvariabele

model = 'unequally spaced'; % gebruik 'unequally spaced' voor het model
% met ongelijk verdeelde tussenaankomsttijden of 'equally spaced' voor
% het model met gelijk verdeelde tussenaankomsttijden

% //////////////////////////////////////////////////////////////////////////

% Maak een 'grid' van waarden voor de twee elementen van x
x1_waarden = linspace(0, 1, 100);
x2_waarden = linspace(0, 1, 100);
[x1, x2] = meshgrid(x1_waarden, x2_waarden);

% Evalueer de doelfunctie voor elke combinatie van x1 en x2
r_waarden = zeros(size(x1));
for i = 1:numel(x1)
    r_waarden(i) = risk([x1(i), x2(i)], n, n0, lambda, p, gamma, model);
end

% 'Reshape' het resultaat voor het maken van een grafiek
r_waarden = reshape(r_waarden, size(x1));

% Maak een 3D plot
figure;
surf(x1, x2, r_waarden);
xlabel('$x_1$', 'Interpreter', 'latex');
ylabel('$x_2$', 'Interpreter', 'latex');
zlabel('$\Phi(\vec{x})$', 'Interpreter', 'latex');

% Voeg een kleurenbalk toe ter referentie
colorbar;
