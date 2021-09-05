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
                    ts_transaction = [];
                    for i = 1 : length(spectrum_bc.mined_block_list) 
                        for j = 1 : length(spectrum_bc.mined_block_list(i).transaction_list) 
                            ts_transaction = [ts_transaction spectrum_bc.mined_block_list(i).transaction_list(j).timestamp_created];        
                        end
                    end
                    for i = 1 : length(spectrum_bc.block_list) 
                        for j = 1 : length(spectrum_bc.block_list(i).transaction_list) 
                            ts_transaction = [ts_transaction spectrum_bc.block_list(i).transaction_list(j).timestamp_created];        
                        end
                    end
                    sorted_transactions = sort(ts_transaction);                    
                    tps{a-1,l}(o,s) = length(sorted_transactions)/sim_time;
                    newCell = {lam(l)+a,l,o,a,s,tps{a-1,l}(o,s)};
                    T = [T;newCell];                    
                end
            end            
        end        
    end
end
%% Plot the results
T.Properties.VariableNames = {'comb','arrivalsRate','nOps','sharingMode','blockSize','tps'};
%subplot(1,3,l)
boxchart(T.comb,T.tps,'GroupByColor',T.nOps)
xticks([3 4 7 8 12 13])
xticklabels({'Auction (\lambda=1)', 'Marketplace (\lambda=1)',...
    'Auction (\lambda=5)', 'Marketplace (\lambda=5)',...
    'Auction (\lambda=10)', 'Marketplace (\lambda=10)'})
ylabel('Overhead (tps)')
grid on
grid minor
set(gca,'FontSize',16,'FontName','Times')
legend({'M=2','M=4','M=8'})  