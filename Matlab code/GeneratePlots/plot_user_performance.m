% Parameters of interest for plotting
to = 10;
lamb = [1 5 10];
auction = 1:2;
num_deployments = 5;
% Process output results from "path_folder"
figure
for l = 1 : 3
    for a = 1 : length(auction)
        for o = 2:9 %1 : length(num_operators)
            path_file = ['Output/output_4_' num2str(auction(a)) '_' ...
                num2str(lamb(l)) '_' num2str(to) '_1_' num2str(o) '_1.mat'];               
            load(path_file)

            total_tpt{a, o-1} = [];  
            total_satisfaction{a, o-1} = [];  

            for k = 1 : num_deployments
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

                new_agg_tpt(k) = sum(averaged_agg_tpt);
                new_mean_tpt(k) = mean(averaged_mean_tpt);
                new_mean_sat(k) = mean(averaged_mean_satisfaction);

                % Gather results for each random depl.
                temporal_agg_tpt(k) = mean(agg_tpt);
                temporal_mean_tpt(k) = mean(mean_tpt);
                temporal_mean_satisfaction(k) = mean(mean_satisfaction);
                temporal_mean_load_aps(k) = mean(mean_load_aps);    

                all_valid_tpt_measurements = throughput_users(ixes_valid_periods,:);
                all_valid_satisfaction_measurements = satisfaction_users(ixes_valid_periods,:);

                total_tpt{a, o-1} = [total_tpt{a, o-1}; all_valid_tpt_measurements(:)];
                total_satisfaction{a, o-1} = [total_satisfaction{a, o-1}; all_valid_satisfaction_measurements(:)];

            %             disp([' - Mean agg. throughput per deployment: ' num2str(new_agg_tpt)])
            %             disp([' - Mean avg. throughput per deployment: ' num2str(new_mean_tpt)])
            end % k = 1 : num_deployments 
            average_agg_tpt(a, o-1) = mean(new_agg_tpt);
            std_agg_tpt(a, o-1) = std(new_agg_tpt);
            average_mean_tpt(a, o-1) = mean(new_mean_tpt);
            std_mean_tpt(a, o-1) = std(new_mean_tpt);
            average_mean_satisfaction(a, o-1) = mean(new_mean_sat);
            std_mean_satisfaction(a, o-1) = std(new_mean_sat);
            average_mean_load_aps(a, o-1) = mean(temporal_mean_load_aps);
            std_mean_load_aps(a, o-1) = std(temporal_mean_load_aps);

        end
    end
    % Barplot mean tpt
    plot_tpt = [average_mean_tpt(1,1) average_mean_tpt(1,3) average_mean_tpt(1,7); ...
        average_mean_tpt(2,1) average_mean_tpt(2,3) average_mean_tpt(2,7)];
    subplot(1,3,l)
    bar((plot_tpt./1e6)')
    ylabel('Mean capacity (Mbps)')
    xlabel('Num. of operators')
    xticks(1:3)
    xticklabels([2 4 8])
    legend({'Static', 'BC-enabled'})
    yyaxis right
    plot_acceptance = [average_mean_satisfaction(1,1) average_mean_satisfaction(1,3) average_mean_satisfaction(1,7); ...
        average_mean_satisfaction(2,1) average_mean_satisfaction(2,3) average_mean_satisfaction(2,7)];
    plot([0.85 1.85 2.85], plot_acceptance(1,:), 'r--x', 'Markersize', 10, 'Linewidth', 2)
    hold on
    plot([1.15 2.15 3.15], plot_acceptance(2,:), 'r--o', 'Markersize', 10, 'Linewidth', 2)
    ylabel('Mean service acceptance')
    grid on
    grid minor
    title(['\lambda = ' num2str(lamb(l))])
    set(gca,'FontSize',18,'FontName','Times')
end

% %% Boxplot tpt
% figure
% x = [];
% g = [];
% for o = 2 : 9
%     x = [x; total_tpt{1, o-1}];
%     g = [g; (o-1)*ones(length(total_tpt{1, o-1}), 1)];
% end
% boxplot(x,g)
% grid on
% grid minor
% set(gca,'FontSize',18,'FontName','Times')

%% Barplot agg tpt
plot_tpt = [average_agg_tpt(1,1) average_agg_tpt(1,3) average_agg_tpt(1,7); ...
    average_agg_tpt(2,1) average_agg_tpt(2,3) average_agg_tpt(2,7)];
figure
bar(plot_tpt')
grid on
grid minor
set(gca,'FontSize',18,'FontName','Times')
title('Agg. tpt')

%% Barplot mean tpt
plot_tpt = [average_mean_tpt(1,1) average_mean_tpt(1,3) average_mean_tpt(1,7); ...
    average_mean_tpt(2,1) average_mean_tpt(2,3) average_mean_tpt(2,7)];
figure
bar(plot_tpt')
grid on
grid minor
set(gca,'FontSize',18,'FontName','Times')
title('Mean tpt')


%title('Avg. tpt')

% % Barplot mean satisfaction
% subplot(1,2,2)
% 
% xlabel('Num. of operators')
% xticks(1:3)
% xticklabels([2 4 8])
% legend({'Static', 'BC-enabled'})
% grid on
% grid minor
% set(gca,'FontSize',18,'FontName','Times')
% %title('Avg. tpt')

%% figure
bar(average_mean_satisfaction');
title('User acceptance')
grid on
grid minor
set(gca,'FontSize',18,'FontName','Times')
xlabel('Num. operators')
ylabel('User acceptance')
legend({'Static', 'Dynamic'})

figure
bar(average_mean_load_aps');
title('BS Load')
grid on
grid minor
set(gca,'FontSize',18,'FontName','Times')
xlabel('Num. operators')
ylabel('Load')
legend({'Static', 'Dynamic'})