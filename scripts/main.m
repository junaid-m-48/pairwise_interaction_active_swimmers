% MAIN SCRIPT FOR SWIMMER SIMULATION
% This script simulates pair-wise interactions between micro-swimmers
% based on the configurations defined in config.m.

% Include configurations
config;

%% Creating Swimmer
[Position, Direction] = createSwimmer(initial_position, initial_orientation, beads_angles, L, swimmerType, bead_diameter, 1);

%% Define max extendible length for spring and diameters of all beads
switch swimmerType
    case 'Two-Bead'
        Lm = 1.15 * L;
        A_mat = [bead_diameter, bead_diameter];
    case 'Three-Bead'
        L(2) = vecnorm(Position{1,2} - Position{1,3});
        Lm = 1.15 * L;
        A_mat = [bead_diameter, bead_diameter/2, bead_diameter/2];
end

%% Solve the force equation
tspan = 0:0.001:3; % total simulation time
interaction_turn_on = 0; % time input when interaction should turn on
p_reshape = cell2mat(reshape(Position', 1, numel(Position)));
x0 = [p_reshape(1,:); p_reshape(2,:); p_reshape(3,:)];

switch swimmerType
    case 'Two-Bead'
        [time, Position] = ode15s(@(t,x) motionDeffTwobead(t, x, propulsion_force, Epsilon, A_mat, L, Lm, H, interaction_turn_on), tspan, x0);
    case 'Three-Bead'
        [time, Position] = ode15s(@(t,x) motionDeffThreebead(t, x, propulsion_force, Epsilon, A_mat, L, Lm, H, interaction_turn_on, 'two-way'), tspan, x0);
end

%% Rearrange Position data
Tdata = restructurePositionData(time, Position, swimmerType);
timeSteps = unique(Tdata(1,:));
no_swimmer = unique(Tdata(2,:));
no_bead = unique(Tdata(3,:));

%% Plot results
plotResults(Tdata, time, timeSteps, no_swimmer, swimmerType, A_mat, video_make, plot_interaction);
