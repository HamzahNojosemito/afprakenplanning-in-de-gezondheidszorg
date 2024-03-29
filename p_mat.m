% Deze matlab-functie berekent de transitiematrix met de kansen
% dat er j patienten zich in het systeem bevinden vlak voor t_i
% Deze matlab-functie is gescheven volgens Mendel (2006)
% Details op: http://www.math.tau.ac.il/~hassin/sharon_thesis.pdf

function M = p_mat(x, n, mu, p)

    e = exp(sym(1));

    % Maak transitiematrix M(x)
    M = zeros(n, n);
    M(1, 1) = 1; 
    
    % Vul de kansen dat er j patienten zich in het systeem bevinden vlak
    % voor t_i in M(x) in 
    for i = 1:n
        for j = 0:(i-1)
            if j == 0
                for k = 0:(i-2)
                    f = 0;
                    for l = 0:(k-1)
                        f = f + (((mu*x(i-1))^l)/factorial(l)) * e^(-mu*x(i-1));
                    end
                    M(i, 1) = M(i, 1) + M(i-1, k+1) * (1 - f  - p*(((mu*x(i-1))^k)/factorial(k))*e^(-mu*x(i-1)));
                end
            else
                g = 0;
                for k = 1:(i-j-1)
                    g = g + M(i-1, j+k) * (((mu*x(i-1))^(k-1))/factorial(k-1)) * e^(-mu*x(i-1)) * ((p*mu*x(i-1))/k + 1 - p);
                end
                M(i, j+1) = M(i, j+1) + g + p*M(i-1, j)*e^(-mu*x(i-1));
            end
        end
    end
end