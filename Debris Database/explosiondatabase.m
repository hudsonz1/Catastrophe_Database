%% Generating explosion database
%
% Second step for the debris generation. 
% Explosion simulation and data storage
%
% IMPORTANT: it is required to have generated initial conditions
% (see orbitdatabase.m)
%
% Run of codes requires strict folder structure to work
% as defined in GitHub readme
% Automatically load and add path of inputs and functions
%
%%%% SEQUENCE
% - Run
% - Input 1: selection of initial conditions (select ICD .mat file)
% - Input 2: propagation time (2 years recommended for data analysis)
%
%%%% OUTPUT
% - explosion_Fam_JC_t0exp_nel.mat's that include:
%       Data of propagated explosions (state vectors for each time step)
%       Other neccesary explosion data 
%       (fragment's mass, type of debris, IC, sexp, texp)
% (\01 orbits\specific_orbit_families\sp_orbit_MM_DD_Family\explosions)
%
%%%% REQUIRED USER FUNCTIONS
% - databasecreate (\00 functions\data_management)
% - somedata (\00 functions\system_data)
% - lagrange (\00 functions\dynamic_model)
% - NASA_BM_EVOLVE4 (\00 functions\explosion_model)
% - explosion (\00 functions\dynamic_model)
% - cr3bp (\00 functions\dynamic_model)
% - JC_CR3BP (\00 functions\dynamic_model)
% - classofdebris (\00 functions\results_analysis)
%
%   Author: Marta Lopez Castro
%   Version: June 04, 2024
% 
% *********************************************************************
% Copyright 2023 - 2025 David Canales Garcia; All Rights Reserved.
% *********************************************************************


%% Explosion Database
clear all; clc; close all

% Find code folder
codepath = fileparts(matlab.desktop.editor.getActiveFilename); 
cd(codepath);

% Add paths
allpaths = genpath(codepath);
addpath(genpath(codepath));

% Prev data
somedata;
load('somedata.mat','*');

% Lagrange Points
Lagrange_Points = lagrange;

% Initial Conditions satellite
msat = 1457;

% Initial Conditions for satellite orbit
[orbitset,orbitpath] = uigetfile(append(cd,'\01 orbits\specific_orbit_families'));
load(append(orbitpath,orbitset),'*');

% Creating folder called explosions
explosionpath = append(orbitpath,'explosions');
mkdir(explosionpath);

% Number of orbits
no = length(t0_exp);

% Propagation time
evol_t_options = {"50 days", "6 months", "1 year", "2 years","other"};
evol_t_idx = listdlg("PromptString",{'Select propagation time'},"SelectionMode","single","ListString",evol_t_options);

% Nondim time
if evol_t_idx == 1
    evol_t = 50*24*3600/tcar;
elseif evol_t_idx == 2
    evol_t = (365/2)*24*3600/tcar;
elseif evol_t_idx == 3
    evol_t = 1*365*24*3600/tcar;
elseif evol_t_idx == 4
    evol_t = 2*365*24*3600/tcar;
else
    answer = inputdlg('Select propagation time (in seconds)');
    evol_t = eval(answer{1})/tcar;
end

% Progress bar
wb = waitbar(0,'Starting ...');
pause(0.1);

for i = 1:no
    % Updating progress bar for each orbit
    waitbar((i-1)/no,wb, sprintf('Calculating velocities of orbit %d/%d', i, no));

    % Catastrophic Mishap (NASA BM)
    lcmin = 0.11; % in m
    
    % Change in velocity
    % Scalar value of the change in velocity
    [vpm,m_debris] = NASA_BM_EVOLVE4(msat,lcmin); % deltav 
    vpm = vpm./(vcar*1000); % deltav nondim
    % Number of fragments
    nel = size(vpm,2);
    % Velocity directions
    vpx = 2.*rand(nel,1) - 1;
    vpy = 2.*rand(nel,1) - 1;
    vpz = 2.*rand(nel,1) - 1;
    vdir = [vpx, vpy, vpz];
    % Change in velocity vector
    vp = vpm'.*vdir./vecnorm(vdir,2,2);
    vp_norm = vecnorm(vp,2,2);
    avg = sum(vp_norm)/nel;

    % Explosion
    ICexp = IC_exp(i,:);
    [s0exp, texp, sexp] = explosion(ICexp,t0_exp(i),evol_t,vp,{wb,i,no});

    % Jacobi Constant
    waitbar(i/no,wb, sprintf('Calculating Jacobi constants of orbit %d/%d', i, no));
    JC = JC_CR3BP(MU,sexp,nel);

    % Class of debris
    waitbar(i/no,wb, sprintf('Calculating results of orbit %d/%d', i, no));
    [orbit_debris, impact_moon, impact_earth, out_of_system] = classofdebris(texp,sexp,rsoie_2BP,rm_star,re_star,r_moon,r_earth);

    % Updating progress bar
    waitbar(i/no,wb, sprintf('Storing data %d/%d', i, no));

    % Store data
    orbit_data = split(orbit_info(i));
    desc = strcat(extractBefore(orbit_data(1),2),extract(orbit_data(1),digitsPattern));
    desc = append(desc{:});
    filename = append(replace(append('explosion_',desc,'_',string(eval(orbit_data{6})),'_',string(eval(orbit_data{10})),'_',string(nel)),'.','-'),'.mat');
    databasecreate(["s0exp", "texp", "sexp", "JC", "orbit_debris", "impact_moon", "impact_earth", "out_of_system","ICexp","m_debris"],append(explosionpath,'\',filename));
    
end

% Close progress bar
close(wb)
