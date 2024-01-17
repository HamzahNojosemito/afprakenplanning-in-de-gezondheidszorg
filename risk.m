function r = risk(x, n, n0, mu, p, cs, model)
    % Define necessary variables
    cw = 1 - cs;
    if strcmpi(model, 'equally spaced')
    x = [zeros(1, n0-1), ones(1, (n-n0)) * x];
    end

    % Calculate the probability matrix P
    P = p_mat(x, n, mu, p);

    % Calculate the waiting times w
    w = zeros(1, n);
    for i = 1:n
        for j = 1:(i-1)
            w(i) = w(i) + (j/mu) * P(i, j+1);
        end
    end

    % Calculate the risk (value of the objective function)
    gamma = cs/(cs + cw);
    gamma_tilde = gamma/(gamma+p*(1-gamma));
    r = (1-gamma_tilde)*sum(w(1, 2:(n-1))) + gamma_tilde*sum(x(1, 1:(n-1))) + w(n);
end