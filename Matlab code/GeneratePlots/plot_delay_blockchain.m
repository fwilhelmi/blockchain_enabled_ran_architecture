clear all
clc

lam = [10];
ops = [2 4 8];
n_deployments = 5;

for o = 1 : length(ops)
    for a = 1 : 3
        agg_tpt_repetition = zeros(1,n_deployments);
        mean_tpt_repetition = zeros(1,n_deployments);
        mean_sat_repetition = zeros(1,n_deployments);        
        for k = 1 : n_deployments
            path_file = ['Output/output_' ...
                num2str(a) '_' num2str(lam) '_10_6000_' ...
                num2str(ops(o)) '_' num2str(k) '.mat'];
            load(path_file);
            % Process sim. results
            agg_tpt = zeros(1,length(period_durations));
            mean_tpt = zeros(1,length(period_durations));
            mean_satisfaction = zeros(1,length(period_durations));
            mean_load_aps = zeros(1,length(period_durations));
            for i = 1 : length(period_durations)
                throughput_in_period = throughput_users(i,:);
                requests_in_period = requests_users(i,:);
                satisfaction_in_period = satisfaction_users(i,:);
                ixes_active_users = find(activation_users(i,:)>0);
                if ~isempty(ixes_active_users)
                    throughput_active_users = throughput_in_period(ixes_active_users);
                    satisfaction_active_users = satisfaction_in_period(ixes_active_users);
                    agg_tpt(i) = sum(throughput_active_users);
                    mean_tpt(i) = mean(throughput_active_users);
                    mean_satisfaction(i) = mean(satisfaction_active_users);
                    mean_load_aps(i) = mean(load_aps(i,:));
                else
                    agg_tpt(i) = -1;
                    mean_tpt(i) = -1;
                    mean_satisfaction(i) = -1;
                    mean_load_aps(i) = -1;
                end
            end
            ixes_valid_periods = [];
            for i = 1 : length(period_durations)                    
                ixes_active_users = find(activation_users(i,:)>0);
                if ~isempty(ixes_active_users) && period_durations(i) > 0
                    ixes_valid_periods = [ixes_valid_periods i];
                end
            end
            averaged_agg_tpt = sum( agg_tpt(ixes_valid_periods) .* ...
                period_durations(ixes_valid_periods)' / sum(period_durations(ixes_valid_periods)) );
            averaged_mean_tpt = sum( mean_tpt(ixes_valid_periods) .* ...
                period_durations(ixes_valid_periods)' / sum(period_durations(ixes_valid_periods)) );
            averaged_mean_satisfaction = sum( mean_satisfaction(ixes_valid_periods) .* ...
                period_durations(ixes_valid_periods)' / sum(period_durations(ixes_valid_periods)) );
            agg_tpt_repetition(k) = mean(averaged_agg_tpt/1e6);
            mean_tpt_repetition(k) = mean(averaged_mean_tpt/1e6);
            mean_sat_repetition(k) = mean(averaged_mean_satisfaction);            
            mean_load_aps_repetition(k) = mean(mean(load_aps));
            std_load_aps_repetition(k) = std(mean(load_aps));            
            mean_req_load_aps_repetition(k) = mean(mean(required_load_aps));
            std_req_load_aps_repetition(k) = std(mean(required_load_aps));          
        end
        aggtpt(a,o) = mean(agg_tpt_repetition);
        stdaggtpt(a,o) = std(agg_tpt_repetition);
        meantpt(a,o) = mean(mean_tpt_repetition);
        stdmeantpt(a,o) = std(mean_tpt_repetition);
        meansat(a,o) = mean(mean_sat_repetition);
        stdsat(a,o) = std(mean_sat_repetition);        
        meanload(a,o) = mean(mean_load_aps_repetition);
        stdload(a,o) = mean(std_load_aps_repetition);        
        meanrload(a,o) = mean(mean_req_load_aps_repetition);
        stdrload(a,o) = mean(std_req_load_aps_repetition);        
    end
end

%%
figure
subplot(1,3,1)
y = 1:length(aggtpt);
h = bar(aggtpt');
hold on
% Find the number of groups and the number of bars in each group
[ngroups, nbars] = size(aggtpt);
% Calculate the width for each bar group
groupwidth = min(0.8, nbars/(nbars + 1.5));
hold off
xlabel('Num. operators')
xticks(1:3)
xticklabels([2 4 8])
ylabel('Agg. capacity (Mbps)')
grid on
grid minor
title('Capacity')
set(gca,'FontSize',16,'FontName','Times')

subplot(1,3,2)
bar(meansat')
hold on
% Find the number of groups and the number of bars in each group
[ngroups, nbars] = size(meansat);
% Calculate the width for each bar group
groupwidth = min(0.8, nbars/(nbars + 1.5));
hold off
xlabel('Num. operators')
title('Satisfaction')
xticks(1:3)
xticklabels([2 4 8])
ylabel('Mean user acceptance')
grid on
grid minor
set(gca,'FontSize',16,'FontName','Times')

subplot(1,3,3)
y = 1:length(meanload);
h = bar(1./(meanload'-meanrload'));
hold on
% Find the number of groups and the number of bars in each group
[ngroups, nbars] = size(meanload);
% Calculate the width for each bar group
groupwidth = min(0.8, nbars/(nbars + 1.5));
hold off
xlabel('Num. operators')
xticks(1:3)
xticklabels([2 4 8])
ylabel('BS efficiency')
title('Efficiency')
grid on
grid minor
set(gca,'FontSize',16,'FontName','Times')
legend({'Static', 'Auction', 'Marketplace'})