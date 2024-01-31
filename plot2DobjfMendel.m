close all
clear
clc

% Met deze code tonen we de tweedimensionale (n=2) grafiek
% van de doelfunctie 'risk'

% De doelfunctie 'risk' is geschreven volgens Mendel (2006)
% Details op: http://www.math.tau.ac.il/~hassin/sharon_thesis.pdf

% //////////////////////////////GEBRUIKERSINPUT/////////////////////////////
% Kies de inputwaarden
n = 2; % aantal patienten
n0 = 1; % aantal patienten ingepland op t = 0
lambda = 3; % 1/lambda is de gemiddelde bedieningsduur (exponentieel)
p = 1; % kans dat de patienten komen opdagen
gamma = 0.5; % gewichtsvariabele

model = 'unequally spaced'; % gebruik 'unequally spaced' voor het model
% met ongelijk verdeelde tussenaankomsttijden of 'equally spaced' voor
% het model met gelijk verdeelde tussenaankomsttijden

% //////////////////////////////////////////////////////////////////////////

% Maak een 2D plot
fplot(@(x) risk(x, n, n0, lambda, p, gamma, model), [0,1])
xlabel('$x_1$', 'Interpreter', 'latex');
ylabel('$\Phi(\vec{x})$', 'Interpreter', 'latex');