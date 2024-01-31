% Met deze matlab-functie optimaliseren we de gegeven doelfunctie
% voor optimale x-waarden (tussenaankomsttijden)
% m.b.v. het FDSA algoritme

% Deze matlab-functie is geschreven volgens Spall (1998)
% Details op: 10.1109/7.705889

function [x, doelfunc_waarde] = fminFDSA(doelfunc, p, m_service)

    % Optimaliseer de doelfunctie met het FDSA algoritme

    x = ones(1,p)*m_service; % beginwaarden voor de x-waarden
    max_iter = 10000; % maximaal aantal iteraties
    % Definieer belangrijke variabelen van het algoritme
    a = 1;
    A = 15;
    c = 1/1000000;
    alfa = 0.602;
    gamma = 0.101;
    tolerantie = 1e-5;

    x_nieuw = zeros(1,p);
    s_plus = zeros(1,p);
    s_minus = zeros(1,p);
    ghat = zeros(1,p);

    % Benader de optimale x-waarden iteratief
    for k = 1:max_iter
        ak = a/(k+A)^alfa;
        ck = c/k^gamma;
        for l = 1:p
            % perturbeer de x-componenten 1 voor 1
            x_plus = x;
            x_plus(l) = x(l) + ck;
            x_minus = x;
            x_minus(l) = x(l) - ck;
            s_plus(l) = doelfunc(x_plus);
            s_minus(l) = doelfunc(x_minus);

            ghat(l) = (s_plus(l) - s_minus(l)) / (2*ck); % schat de gradient
                                                    % bij de bijbehorende x
            x_nieuw(l) = x(l) - ak*ghat(l); % update de x-waarde
        end

        % Check of het de geupdate x-waarden niet veel verschilt van de
        % vorige
        gem_verschil = sum(abs(x_nieuw - x))/p;
        if gem_verschil < tolerantie
            break;
        end
        % Vervang de oude x met de nieuwe x
        x = x_nieuw;

        % Toon informatie van de voltooide iteratie
        fprintf('Iteratie: %d', k);
        fprintf('\nGemiddeld verschil: %f\n', gem_verschil);
        fprintf('Huidige geoptimaliseerde x-waarden:\n %.4f', x(1));
        for m = 2:p
            fprintf(', %.4f', x(m));
        end
        fprintf('\n\n')
    end

    % Toon de optimale x-waarden en de bijbehorende doelfunctiewaarden
    doelfunc_waarde = doelfunc(x);
    fprintf('De optimale x-waarden zijn:\n %.4f', x(1));
    for i = 2:p
        fprintf(', %.4f', x(i));
    end
    fprintf('\nEn de doelfunctiewaarde is: %.4f.\n', doelfunc_waarde);
end