%%% *********************************************************************
%%% * Blockchain-Enabled RAN Sharing for Future 5G/6G Communications    *
%%% * Authors: Lorenza Giupponi & Francesc Wilhelmi (fwilhelmi@cttc.cat)*
%%% * Copyright (C) 2020-2025, and GNU GPLd, by Francesc Wilhelmi       *
%%% * GitHub repository: ...                                            *
%%% *********************************************************************

%%% File description: script for running multiple simulations, based on the
%%% parameters defined in "conf_simulation"

clear
close all
clc

% Load constants
constants
conf_simulation_operators

%%
for o = 1 : length(num_operators)
    ownedApsRatio = zeros(1, num_operators(o));
%     ownedApsRatio(1) = 1;
    for k = 1 : num_deployments
        disp(['Deployment ' num2str(k) '/' num2str(num_deployments)])
        
        r = rand(1, num_operators(o)); % Start with 3 random numbers that don't sum to 1.
        r2 = r / sum(r);
        ownedApsRatio = round(r2,2);
        % Normalize so the sum is 1.
%         % Define the ratio of APs owned by each operator
%         for i = 1 : num_operators(o) 
%             if i < num_operators(o)
%                 ownedApsRatio(i) = 1/num_operators(o);
%             else
%                ownedApsRatio(i) = 1-sum(ownedApsRatio(1:end-1)); 
%             end
%         end    
        % Generate the deployment
        deployment = GenerateDeployment(nStas);
        % Create MNOs (assign resources to BSs) and users
        [deployment, operators] = CreateOperators(deployment, num_operators(o), ownedApsRatio);
        users = GenerateUsers(deployment);
        % Determine miners and computational power
        [deployment, miners] = InitializeMiners(deployment);   
        %if PLOTS_ENABLED, DrawDeployment(deployment); end
        if LOGS_ENABLED, PrintSimulationDetails(deployment, operators, users); end
        % Iterate for each value of user activity (number of requests per second)
        %disp(['Service auction type = ' num2str(service_auction_modes(a))])
        for aa = 1 : length(spectrum_leasing_modes)
            disp([' . Spectrum auction type = ' num2str(spectrum_leasing_modes(aa))])
            for l = 1 : length(lambda)
                % Iterate for each value of user activity (number of requests per second)
                disp(['   + Users arrivals (lambda) = ' num2str(lambda(l))])
                % Iterate for each block timeout
                for t = 1 : length(block_timeout)
                    %disp(['     * Block timeout = ' num2str(block_timeout(t))])
                    % Iterate for each block size
                    for s = 1 : length(block_size_spectrum)    
                        MAX_BLOCK_SIZE = TRANSACTION_LENGTH*block_size_spectrum(s);       % Maximum block size in bits                
                        % RUN THE SIMULATION
                        RunSimulation(deployment, operators, users, miners, ...
                            spectrum_leasing_modes(aa), lambda(l), block_timeout(t), MAX_BLOCK_SIZE, k);                      
                    end % end "for" block size values
                end % end "for" timer values      
            end % end "for" lambda values  
        end % end "for" spectrum auction modes    
    end
end