% Met deze matlab-functie optimaliseren we de gegeven doelfunctie
% voor optimale x-waarden (tussenaankomsttijden)
% m.b.v. het SPSA algoritme

% Deze matlab-functie is geschreven volgens Spall (1998)
% Details op: 10.1109/7.705889

function [x, doelfunc_waarde] = fminSPSA(doelfunc, p, m_service)

    % Optimaliseer de doelfunctie met het SPSA algoritme

    x = ones(1,p)*m_service; % beginwaarden voor de x-waarden
    max_iter = 10000; % maximaal aantal iteraties
    % Definieer belangrijke variabelen van het algoritme
    A = 10;
    c = 1e-3;
    alfa = 0.602;
    gamma = 0.101;
    a = (1/2)*m_service*((A+1)^alfa);
    tolerantie = 1e-5;
    
    % Benader de optimale x-waarden iteratief
    for k = 1:max_iter
        ak = a/(k+A)^alfa;
        ck = c/k^gamma;

        grad_schattingen = 2; % gebruik de gemiddelde van 2 gradient
                              % schattingen in elke iteratie
        ghat_matrix = zeros(grad_schattingen,p);
        for l = 1:grad_schattingen
            delta = (2 * round(rand(p, 1)) - 1).'; % genereer de 
                                                   % perturbatievector delta

            % perturbeer alle x-componenten gelijktijdig per gradient
            % schatting
            x_plus = x + ck*delta;
            x_minus = x - ck*delta;
            yplus = doelfunc(x_plus);
            yminus = doelfunc(x_minus);
            ghat_matrix(l,:) = (yplus - yminus) ./ (2*ck*delta); 
        end
        ghat = mean(ghat_matrix, 1); % bereken de gemiddelde geschatte gradient

        x_nieuw = x - ak*ghat; % update de x-waarden
    
        % Check of het de geupdate x-waarden niet veel verschilt van de
        % vorige
        gem_verschil = sum(abs(x_nieuw - x))/p;
        if gem_verschil < tolerantie
            % Vervang de oude x met de nieuwe x
            x = x_nieuw;
            break;
        end
        % Vervang de oude x met de nieuwe x
        x = x_nieuw;

        % Toon informatie van de voltooide iteratie
        fprintf('Iteratie: %d', k);
        fprintf('\nGemiddeld verschil: %f\n', gem_verschil);
        fprintf('Huidige geoptimaliseerde x-waarden:\n %.4f', x(1));
        for l = 2:p
            fprintf(', %.4f', x(l));
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