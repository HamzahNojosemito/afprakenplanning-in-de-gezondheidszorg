close all
clear
clc

% In this code we search the optimal x values (inter arrival times)
% The objective function is obtained by simulation

% ////////////////////////////////USER INPUT////////////////////////////////
% Determine the input values
n = 5; % number of patients
w = 0.5; % weight factor omega
sims = 1000000; % number of simulations per iteration

B = zeros(sims, n);
% Choose a distribution for the service times
% and define the service times in all k simulations
% which will not change for all iterations in the optimization process

% Service times with exponential distribution
mu = 7;
m_service = 1/mu;
for i = 1:sims
    B(i,:) = exprnd(m_service, 1, n);
end

% % Service times with gamma distribution
% k = 9;
% theta = 0.5;
% m_service = k*theta;
% for i = 1:sims
%     B(i,:) = gamrnd(k, theta, 1, n);
% end

% % Service times with uniform distribution
% lwr = 0;
% upr = 2/3;
% m_service = (lwr+upr)/2;
% for i = 1:sims
%     B(i,:) = unifrnd(lwr, upr, 1, n);
% end

% //////////////////////////////////////////////////////////////////////////



% Define the objective function to optimize
f = @(x)risk_sim(x, n, w, sims, B);

% Optimize the objective function with the Kiefer-Wolvowitz Algorithm
[optimal_x, f_val] = fminSPSA_avgGrad(f, n-1, m_service);

% Create array for the number of inter-arrivals
inter_arrival = 1:length(optimal_x);

% % Plotting
% plot(inter_arrival, optimal_x, 'o-');
% xlabel('i-de tussenaankomsttijd');
% ylabel('Tussenaankomsttijd (minuten)');




