% CONFIGURATION FILE
% This script initializes parameters for simulating pair-wise interactions
% between micro-swimmers.

% PARAMETERS

% Bead diameter (in mm)
bead_diameter = 5e-3; % a_b

% Propulsion forces for each swimmer 
% Changing the sign will change the stresslet sign
propulsion_force = [2e-8, 2.5e-8];

% Length of the spring between beads (in mm)
L = 3 * bead_diameter;

% Type of swimmer ("Two-Bead" or "Three-Bead")
swimmerType = 'Three-Bead';

% Initial positions of swimmers in 3D space (in mm)
initial_position = [-15, 0, 0;
                    15, 0, -50] * 1e-3;

% Initial orientations of swimmers (in degrees)
initial_orientation = [0, -90, 0;
                       0, -90, 0];

% Beads angles for three-bead swimmers (in radians)
if strcmp(swimmerType, 'Three-Bead')
    beads_angles = [deg2rad(60), deg2rad(30);  % [phi_swimmer_1, alpha_swimmer_1]
                    deg2rad(60), deg2rad(0)]; % [phi_swimmer_2, alpha_swimmer_2]
else
    beads_angles = [];
end

% Video creation option ('on' or 'off')
video_make = 'on';

% Option to plot interaction in 3D space ('on' or 'off')
plot_interaction = 'on';

% Coefficient for spring force calculation
H = abs(propulsion_force(1)) / (0.01 * L);

% Coefficient for friction force
Epsilon = propulsion_force(1) * 1e-5;
