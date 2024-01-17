% Create a function that simulates a single server queueing system
% which returns the expected idle time and expected waiting time
function risk = risk_sim(inter_arr_time, n, w, k, B)
    arrival_t = @(inter_arr_time) [0, cumsum(inter_arr_time)]; % Define times function
    t = arrival_t(inter_arr_time); % arrival times

    sum_idle_sims = zeros(1, n);
    sum_wait_sims = zeros(1, n);
    
    for a = 1:k
        
        departure = [B(a, 1), NaN(1, n-1)]; % departure time
        wait = zeros(1, n);
        
        for j = 2:n
            if t(j) > departure(j-1)
                sum_idle_sims(j) = sum_idle_sims(j) + t(j) - departure(j-1);
            else
                wait(j) = departure(j-1) - t(j);
                sum_wait_sims(j) = sum_wait_sims(j) + wait(j);
            end
            departure(j) = t(j) + B(a, j) + wait(j);
        end
    end
    
    e_idle = sum_idle_sims / k; % expected idle time
    e_wait = sum_wait_sims / k; % expected waiting time

    % Return the value of the objective function
    risk = w * sum(e_idle) + (1-w) * sum(e_wait);
end
