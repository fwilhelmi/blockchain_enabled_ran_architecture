clear all
clc

% Define parameters used in simulations
lam = [1 5 10];
sb = 1:10;
tim = 10; %[.1 1 10];
ops = [2 4 8];

% Process the simulation output files
T = table(); % arrivalsRate,nOps,sharingMode,blockSize,tps
for l = 1 : length(lam)
    for o = 1 : length(ops)
        for a = 2 : 3  
            for s = 1 : length(sb)
                for tt = 1 : length(tim)
                    max_bs = 3000*sb(s);
                    path_file = ['Output/results_bc_delay/output_' num2str(a) ...
                        '_' num2str(lam(l)) '_' num2str(tim(tt)) '_' num2str(max_bs) '_' ...
                        num2str(ops(o)) '_1.mat'];
                    load(path_file);
                e2e_delay = [];
                % SPECTRUM BC
                for i = 1 : length(spectrum_bc.mined_block_list)        
                    for j = 1 : length(spectrum_bc.mined_block_list(i).transaction_list)        
                        ts_created = spectrum_bc.mined_block_list(i).transaction_list(j).timestamp_created;
                        ts_served = spectrum_bc.mined_block_list(i).transaction_list(j).timestamp_served;
                        if ts_served > 0
                            e2e_delay = [e2e_delay ts_served-ts_created];
                        end   
                    end
                end
                endtoend_delay{a-1,l}(o,s) = mean(e2e_delay);
                newCell = {lam(l)+a,l,o,a,s,endtoend_delay{a-1,l}(o,s)};
                T = [T;newCell];                    
                end
            end            
        end        
    end
end
%% Plot the results
T.Properties.VariableNames = {'comb','arrivalsRate','nOps','sharingMode','blockSize','delay'};
%subplot(1,3,l)
boxchart(T.comb,T.delay,'GroupByColor',T.nOps)
xticks([3 4 7 8 12 13])
xticklabels({'Auction (\lambda=1)', 'Marketplace (\lambda=1)',...
    'Auction (\lambda=5)', 'Marketplace (\lambda=5)',...
    'Auction (\lambda=10)', 'Marketplace (\lambda=10)'})
ylabel('T_{BC} (s)')
grid on
grid minor
set(gca,'FontSize',16,'FontName','Times')
legend({'M=2','M=4','M=8'}) 