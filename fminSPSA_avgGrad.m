function [theta, loss_value] = fminSPSA_avgGrad(loss, p, m_service)

    % Optimize the objective function with the SPSA Algorithm
    theta = ones(1,p)*m_service;
    n = 1000; % max number of iterations
    A = 100;
    c = 1e-3;
    alpha = 0.602;
    gamma = 0.101;
    a = (1/2)*m_service*((A+1)^alpha);
    tolerance = 1e-5;

    for k = 1:n
        ak = a/(k+A)^alpha;
        ck = c/k^gamma;

        grad_approximations = 2;
        ghat_matrix = zeros(grad_approximations,p);
        for l = 1:grad_approximations
            delta = (2 * round(rand(p, 1)) - 1).';
            thetaplus = theta + ck*delta;
            thetaminus = theta - ck*delta;
            yplus = loss(thetaplus);
            yminus = loss(thetaminus);
            ghat_matrix(l,:) = (yplus - yminus) ./ (2*ck*delta);
        end
        ghat = mean(ghat_matrix, 1);

        theta_new = theta - ak*ghat;

        difference = sum(abs(theta_new - theta))/p;
        if difference < tolerance
            break;
        end
        % Replace the old theta with the new theta
        theta = theta_new;

        % Print information about the completed iteration
        fprintf('Iteration: %d', k);
        fprintf('\nDifference: %f\n', difference);
        fprintf('Current optimized x values:\n %.4f', theta(1));
        for l = 2:p
            fprintf(', %.4f', theta(l));
        end
        fprintf('\n\n')
    end

    loss_value = loss(theta);

    % Print the theta values and the corresponding loss function value
    fprintf('The optimal x values are:\n %.4f', theta(1));
    for i = 2:p
        fprintf(', %.4f', theta(i));
    end
    fprintf('\nAnd the f value is: %.4f.\n', loss_value);
end