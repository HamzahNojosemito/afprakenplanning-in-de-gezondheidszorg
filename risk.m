% Deze matlab-functie berekent de doelfunctiewaarde
% aan de hand van Mendel (2006)
% Details op: http://www.math.tau.ac.il/~hassin/sharon_thesis.pdf

function r = risk(x, n, n0, lambda, p, gamma, model)
    % Maak alle tussenaankomsttijden gelijk als het 'equally spaced' model
    % wordt gebruikt
    if strcmpi(model, 'equally spaced')
    x = [zeros(1, n0-1), ones(1, (n-n0)) * x];
    end
    
    % Bereken de transitiematrix P
    P = p_mat(x, n, lambda, p);

    % Bereken de wachttijden w
    w = zeros(1, n);
    for i = 1:n
        for j = 1:(i-1)
            w(i) = w(i) + (j/lambda) * P(i, j+1);
        end
    end

    % Bereken de doelfunctiewaarde
    gamma_tilde = gamma/(gamma+p*(1-gamma));
    r = (1-gamma_tilde)*sum(w(1, 2:(n-1))) + gamma_tilde*sum(x(1, 1:(n-1))) + w(n);
end