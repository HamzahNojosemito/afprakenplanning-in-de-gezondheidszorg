close all
clear
clc

% Met deze code zoeken we de optimale x-waarden (tussenaankomsttijden)
% voor verschillende gamma-waarden (waarden voor de gewichtsvariabele)
% gebruikmakend van de ingebouwde Matlab-functie 'fmincon'
% Details op: https://www.mathworks.com/help/optim/ug/fmincon.html

% De doelfunctie 'risk' is geschreven volgens Mendel (2006)
% Details op: http://www.math.tau.ac.il/~hassin/sharon_thesis.pdf

gamma_array = [0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875, 1]; % reeks
                                    % met waarden voor de gewichtsvariabele
for gamma = gamma_array
    % //////////////////////////////GEBRUIKERSINPUT/////////////////////////////
    % Kies de inputwaarden
    n = 11; % aantal patienten
    n0 = 1; % aantal patienten ingepland op t = 0
    lambda = 3; % 1/lambda is de gemiddelde bedieningsduur (exponentieel)
    p = 1; % kans dat de patienten komen opdagen

    model = 'unequally spaced'; % gebruik 'unequally spaced' voor het model
    % met ongelijk verdeelde tussenaankomsttijden of 'equally spaced' voor
    % het model met gelijk verdeelde tussenaankomsttijden

    % //////////////////////////////////////////////////////////////////////////
    
    
    % Definieer belangrijke variabelen voor optimalisatie
    if strcmpi(model, 'equally spaced')
        x0 = 1; % beginwaarde voor alle gelijke x-waarden
        lb = 0; % ondergrens
        ub = Inf; % bovengrens
        A = []; % geen ongelijkheidsvoorwaarden
        b = [];
        Aeq = []; % geen gelijkheidsvoorwaarden
        beq = [];
        nonlcon = [];
    elseif strcmpi(model, 'unequally spaced')
        x0 = ones(1, n-1); % beginwaarden voor de x-waarden
        lb = zeros(1, n-1); % ondergrens
        ub = ones(1, n-1) * Inf; % bovengrens
        A = []; % geen ongelijkheidsvoorwaarden
        b = [];
        if n0 == 1 % als 1 patient op t=0 is ingepland
            Aeq = []; % geen gelijkheidsvoorwaarden
            beq = [];
        else % als meer dan 1 patient op t=0 is ingepland
            Aeq = zeros(n0-1, n-1); % gelijkheidsvoorwaarden
            for i = 1:(n0-1)
                Aeq(i, i) = 1;
            end
            beq = zeros(1, n0-1);
        end
        nonlcon = [];
    end

    % Gebruik 'fmincon' met het 'sequential quadratic programming (sqp)
    % algoritme
    options = optimoptions('fmincon','Display','iter','Algorithm','sqp');
    
    % Optimaliseer de doelfuntie 'risk' voor optimale x-waarden
    f = @(x)risk(x, n, n0, lambda, p, gamma, model);
    [optimale_x, f_waarde] = fmincon(f, x0, A, b, Aeq, beq, lb, ub, nonlcon, options); % optimale x-waarden
    if strcmpi(model, 'equally spaced')
        optimale_x = [zeros(1, n0-1), ones(1, n-n0) * optimale_x];
    end
    
    % Toon de optimale x-waarden en de bijbehorende doelfunctiewaarde
    fprintf('De optimale tussenaankomsttijden zijn:\n %.4f', optimale_x(1));
    for i = 2:length(optimale_x)
        fprintf(', %.4f', optimale_x(i));
    end
    fprintf('\nEn de doelfunctiewaarde is: %.4f.\n', f_waarde);
    
    % Maak een vector met alle i (= 1,2,...n)
    i = 1:length(optimale_x);
    
    % Plotten
    plot(i, optimale_x, 'o-');
    xlabel('$i$', 'Interpreter', 'latex');
    ylabel('$x_i$', 'Interpreter', 'latex');
    hold on
end
hold off

% Maak een legenda voor de grafiek
string_array = cell(size(gamma_array));
for i = 1:numel(gamma_array)
    string_array{i} = ['\gamma=' rats(gamma_array(i))];
    string_array{i} = strrep(string_array{i}, ' ', '');
end
legend(string_array,'Location','best','Orientation','vertical')
lgd = legend;
lgd.NumColumns = 2;