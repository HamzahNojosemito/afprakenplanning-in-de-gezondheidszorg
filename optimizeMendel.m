close all
clear
clc

% In this code we search the optimal x values (inter arrival times)
% using the matlab function 'fmincon'
% Details at: https://www.mathworks.com/help/optim/ug/fmincon.html

% The objective function 'risk' is written according to Mendel(2006)
% Details at: http://www.math.tau.ac.il/~hassin/sharon_thesis.pdf

% ////////////////////////////////USER INPUT////////////////////////////////
% Define necessary variables for objective function
n = 5; % number of patients
n0 = 1; % number of patients scheduled at t = 0
mu = 7; % 1/mu is the mean service time (exponential)
p = 1; % chance of the patients showing up
cs = 0.5;
model = 'unequally spaced'; % use 'equally spaced' or 'unequally spaced' model
% //////////////////////////////////////////////////////////////////////////


% Define necessary variables for optimization
if strcmpi(model, 'equally spaced')
    x0 = 1; % initial x values
    lb = 0; % lower bound
    ub = Inf; % upper bound
    A = []; % no inequality constraints
    b = [];
    Aeq = []; % no equality constraints
    beq = [];
    nonlcon = [];
elseif strcmpi(model, 'unequally spaced')
    x0 = ones(1, n-1); % initial x values
    lb = zeros(1, n-1); % lower bound
    ub = ones(1, n-1) * Inf; % upper bound
    A = []; % no inequality constraints
    b = [];
    if n0 == 1
        Aeq = []; % no equality constraints
        beq = [];
    else
        Aeq = zeros(n0-1, n-1); % equality constraints
        for i = 1:(n0-1)
            Aeq(i, i) = 1;
        end
        beq = zeros(1, n0-1);
    end
    nonlcon = [];
end
options = optimoptions('fmincon','Display','iter','Algorithm','sqp');

% Optimize objective function "risk" for optimal x values
f = @(x)risk(x, n, n0, mu, p, cs, model);
[iat, f_val] = fmincon(f, x0, A, b, Aeq, beq, lb, ub, nonlcon, options); % optimal x values
if strcmpi(model, 'equally spaced')
    iat = [zeros(1, n0-1), ones(1, n-n0) * iat];
end

% Print the optimal x values and the corresponding objective function value
fprintf('The optimal x values are:\n %.4f', iat(1));
for i = 2:length(iat)
    fprintf(', %.4f', iat(i));
end
fprintf('\nAnd the f value is: %.4f.\n', f_val);


% Generate iat_i-values from 1 to the length of iat
iat_i = 1:length(iat);

% % Plotting
% plot(iat_i, iat, 'o-');
% xlabel('i-de tussenaankomsttijd');
% ylabel('Tussenaankomsttijd (minuten)');
% title('Tussenaankomsttijd (minuten) vs. i-de tussenaankomsttijd');


