% Script to initialize the repository
disp('Initializing myCheetahSim repository...');

% Define the base directory for the repository
baseDir = fileparts(mfilename('fullpath'));  % Gets the directory of
addpath(genpath(baseDir));

% Display a message confirming initialization is complete
disp('CheetahSim environment initialized.');
