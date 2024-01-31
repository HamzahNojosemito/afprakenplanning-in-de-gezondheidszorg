% Deze matlab-functie simuleert een enkelvoudig wachtrij-systeem van 1 server
% De doelfunctie is geschreven volgens Kuiper (2016)
% Details op: https://pure.uva.nl/ws/files/2776103/174963_AlexKuiper_Thesis_complete.pdf

function risk = risk_sim(tussenaankomsttijden, n, w, k, B)
    aankomsttijden = @(tussenaankomsttijden) [0, cumsum(tussenaankomsttijden)]; % Definieer
                                                % een matlab-functie voor aankomsttijden
    t = aankomsttijden(tussenaankomsttijden); % aankomsttijden

    sum_inactv_sims = zeros(1, n); % Maak een reeks voor de inactieve tijden
    sum_wacht_sims = zeros(1, n); % Maak een reeks voor de wachttijden
    
    for a = 1:k
        
        vertrek_t = [B(a, 1), NaN(1, n-1)]; % reeks voor het opslaan van
                                            % vertrektijden van patienten
        wacht_t = zeros(1, n); % reeks voor het opslaan van wachttijden
                            % van patienten
        
        for j = 2:n
            % Als de aankomsttijd van de j-de patient later is dan
            % de vertrektijd van de (j-1)-de patient, dan ontstaat
            % inactieve tijd
            if t(j) > vertrek_t(j-1)
                sum_inactv_sims(j) = sum_inactv_sims(j) + t(j) - vertrek_t(j-1);
            else
            % Anders ontstaat wachttijd of helemaal geen
            % wachttijd/inactieve tijd
                wacht_t(j) = vertrek_t(j-1) - t(j);
                sum_wacht_sims(j) = sum_wacht_sims(j) + wacht_t(j);
            end
            vertrek_t(j) = t(j) + B(a, j) + wacht_t(j); % vertrektijd van patient j
        end
    end
    
    e_inactv_t = sum_inactv_sims / k; % verwachte inactieve tijd
    e_wacht_t = sum_wacht_sims / k; % verwachte wachttijd

    % Geef de waarde van de doelfunctie terug
    risk = w * sum(e_inactv_t) + (1-w) * sum(e_wacht_t);
end
