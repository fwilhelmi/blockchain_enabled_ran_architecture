%%% *********************************************************************
%%% * Blockchain-Enabled RAN Sharing for Future 5G/6G Communications    *
%%% * Authors: Lorenza Giupponi & Francesc Wilhelmi (fwilhelmi@cttc.cat)*
%%% * Copyright (C) 2020-2025, and GNU GPLd, by Francesc Wilhelmi       *
%%% * GitHub repository: ...                                            *
%%% *********************************************************************

%%% File description: script for storing the configuration of simulations

% Set simulation parameters
sim_time = 300;          % Simulation time
num_deployments = 1;	% Number of random deployments to be simulated
PLOTS_ENABLED = 1;      % Flag to enable plots
LOGS_ENABLED = 0;       % Flag to enable logs (write logs in file)

% Deployment characteristics
nRings = 2;                 % Number of rings in the deployment (max=2)
R = 10;                     % Cell radius
nStas = 200;                % Number of STAs
num_operators = [4 8];    % Number of operators in the deployment

% Blockchain parameters
block_timeout = [0.1 1 10];     % List of timeouts (in seconds) for generating a block
block_size_spectrum = 1:10;     % Bock size in number of transactions (spectrum BC)
queue_length = 1000;            % Number of transactions that fit the queue of unconfirmed transactions
lambda = [1 5 10];              % List of arrivals rates (UE requests)
FORKS_ENABLED = 0;              % Enable/disable Forks
RETRANSMISSIONS_ENABLED = 0;    % Enable/disable retransmissions
MINING_DIFFICULTY = 1;          % Mining difficulty
TRANSACTION_LENGTH = 3000;      % Length of a transaction in bits
HEADER_LENGTH = 640;            % Length of a transaction in bits
mu = 10;                        % Mining capacity (blocks per second) - Service BC
mu_spectrum = 5;                % Mining capacity (blocks per second) - Spectrum BC

% Auction parameters
operator_selection_mode = SELECTION_RANDOM; %SELECTION_NEAREST_AP
spectrum_leasing_modes = ...
    [LEASE_STATIC  LEASE_AUCTION LEASE_MARKETPLACE];     % List of spectrum leasing modes (how operators exchange resources)
marketplace_options = [0.1 0.3 0.5];
maxPricePerServiceUnit = 1;                             % Maximum price per unit of service
minPricePerServiceUnit = 1;                             % Minimum price per unit of service
sellerAttitude = 1;                                     % Sellers' attitude
bid_submission_mode = SUBMIT_BIDS_INDIVIDUALLY; % SUBMIT_BIDS_TOGETHER

% Users' behavior
deltaActivationProbability = 0.01;  % Interval between discretized steps
minServiceDuration = 10;            % Minimum service duration in seconds
maxServiceDuration = 60;            % Maximum service duration in seconds
deltaServiceDuration = 1;          % Interval between discretized steps
minThroughputReq = 0.001;           % Minimum throughput required in bps
maxThroughputReq = 0.01;            % Maximum throughput required in bps
deltaThroughputReq = 0.001;         % Interval between discretized steps
minDelayReq = 0.1;                  % Minimum delay required in seconds
maxDelayReq = 5;                    % Maximum delay required in seconds
deltaDelayReq = 0.1;                % Interval between discretized steps

% Planning mode for allocating resources to BSs
%   * WIFI_SINGLE_CHANNEL_RANDOM = 1;
%   * WIFI_SINGLE_CHANNEL_ALL_SAME = 2;
PLANNING_MODE = 1; 

% Interference mode
INTERFERENCE_MODE = 1;  % 0-Real, 1-Worst-case

% Generic PHY modeling constants
PATH_LOSS_MODEL = 1;                % Path loss model index
NUM_CHANNELS_SYSTEM = 1;            % Maximum allowed number of channels for a single transmission

save('./tmp/conf_simulation.mat');  % Save constants into the current folder