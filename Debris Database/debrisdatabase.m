%% Generating debris database and plotting results
%
% Third and last step for the debris generation. 
% Explosion data compiling and plotting
%
% IMPORTANT: it is required to have generated explosions
% (see explosiondatabase.m)
%
% Run of codes requires strict folder structure to work
% as defined in GitHub
% Automatically load and add path of inputs and functions
%
%%%% SEQUENCE
% - Run
% - Input 1: selection of specific orbits 
%            (list from folders generated in orbitdatabase.m)
% - Input 2: explosions to be studied
% - Input 3: yes/no debris storage 
%            (Not recommended: memory consumming
%                              and explosion data compilation is fast)
% - Input 4: yes/no plotting 
%           (A propagation time of 2 years is mandatory)
%
%%%% OUTPUT
% variables with debris data loaded in workspace (*_all)
% (optional) debris.mat with stored debris data
% (optional) plots saved in \02 orbits\foldername
%
%   Author: Marta Lopez Castro
%   Version: July 25, 2024
 
% *********************************************************************
% Copyright 2023 - 2025 David Canales Garcia; All Rights Reserved.
% *********************************************************************

%% Debris database

%% Initialization

% Set current folder and add paths
codepath = fileparts(matlab.desktop.editor.getActiveFilename); 
cd(codepath);
allpaths = genpath(codepath);
addpath(genpath(codepath));

% Set default figure position
set(groot,'defaultFigurePosition',[2733,118,560,420]);

% Search for existing explosion databases for GUI
Orbitsfiles = what('orbit_families');
Families = erase(Orbitsfiles.mat,'.mat');
Families_desc = cellfun(@(x) strcat(extractBefore(x,2),extract(x,digitsPattern)),Families,'UniformOutput',false);
cd(append(codepath,'\01 orbits\specific_orbit_families'))
explosioncell = struct2cell(dir('sp_*'));
explosionparts = split(explosioncell(1,:),'_');

% User define selected explosions to load
exp_idx = listdlg("PromptString",{'Select orbit databases'},"ListString",explosioncell(1,:),"SelectionMode","multiple");
orb_files = cellfun(@what,strcat(explosioncell(2,exp_idx),'\',explosioncell(1,exp_idx),'\orbits'));


%% Load data

%Initialize variables
t0exp_all = [];
JC0_all = [];

texp_all = {};
sexp_all = {};
s0exp_all = [];
out_of_system_all = [];
orbit_debris_all = [];
JC_all = [];
impact_moon_all = [];
impact_earth_all = [];
IC_exp_all = [];
m_debris_all = [];
nel_all = [];
orbit_family_all = [];
orb_files_all = {};

% Load data explosion databases
for i = 1:length(exp_idx)
    % Select specific explosions
    expfiles = what(append(explosioncell{1,exp_idx(i)},'\explosions'));
    parts = replace(erase(split(expfiles.mat,'_'),'.mat'),'-','.');
    sp_exp_idx{i} = listdlg("PromptString",{'Select explosions'},"ListString",erase(expfiles.mat,'.mat'));
    % Extract explosion data from file names
    orbit_family = string(parts(:,2));
    JC0 = cellfun(@eval,parts(:,3));
    t0exp = cellfun(@eval,parts(:,4));
    nel = cellfun(@eval,parts(:,5));

    % .mat files to load
    orb_files_all = vertcat(orb_files_all,strcat(explosioncell(2,exp_idx(i)),'\',explosioncell(1,exp_idx(i)),'\orbits\',orb_files(i).mat));

    % Load and save data from each explosion
    for j = 1:length(sp_exp_idx{i})
        % Progress
        disp(string(j))

        % Load file
        idx = sp_exp_idx{i}(j);
        load(expfiles.mat{idx});

        %Save data
        t0exp_all = horzcat(t0exp_all,ones(1,length(texp))*t0exp(idx)); % Explosion time
        JC0_all = horzcat(JC0_all,ones(1,nel(idx))*JC0(idx)); % Jacobi constant of IC
        texp_all = horzcat(texp_all,texp); % time vector of debris
        sexp_all = horzcat(sexp_all,sexp); % state vector of debris
        s0exp_all = vertcat(s0exp_all,s0exp); % state vector of IC (after deltaV)
        out_of_system_all = horzcat(out_of_system_all,out_of_system); % indexing vector for out of system
        orbit_debris_all = horzcat(orbit_debris_all,orbit_debris); % indexing vector for orbiting debris
        impact_moon_all = horzcat(impact_moon_all,impact_moon); % indexing vector for impact Moon
        impact_earth_all = horzcat(impact_earth_all,impact_earth); % indexing vector for impact Earth
        JC_all = horzcat(JC_all,JC); % Jacobi constant of debris
        IC_exp_all = vertcat(IC_exp_all,ICexp); % IC of each explosion
        m_debris_all = horzcat(m_debris_all, m_debris); % mass
        nel_all = horzcat(nel_all, nel(idx));
        for k = 1:nel(idx)
            orbit_family_all = horzcat(orbit_family_all,orbit_family(idx,:)); % Orbit family name
        end
    end

end

% In workspace only remains compiled explosion data
clearvars -except *_all 

% Store debris data (optional)
if isequal('Yes',questdlg('Do you want to store data?', '.mat generation', 'Yes','No','No'))
    save debris.mat *_all
end



%% plots

% Example of different plots obtained
% A propagation time of 2 years and IC with more than 1 value of JC are
% required

% User defines plotting options
if isequal('Yes',questdlg('Do you want to plot?', 'Plotting', 'Yes','No','No'))
answer = inputdlg({'Folder name','Data name','Color number'},'Save data in:',[1 60;1 60; 1 60],{'Folder name','L1 Lyapunov','1'});
foldername_all = answer{1};
analysisname_all = answer{2};
coloridx_all = eval(answer{3});

% Create folder to store plots
codepath = fileparts(matlab.desktop.editor.getActiveFilename); 
cd(codepath);
folder = append(codepath,'\02 plots\',foldername_all,'\',analysisname_all);
mkdir(append(codepath,'\02 plots\',foldername_all));
mkdir(folder);

% Define variables
s0exp_unique = unique(s0exp_all(:,1:3),'rows'); % state vectors of IC (remove repeated)
[JC0,idx] = unique(JC0_all); % Jacobi constant of IC (remove repeated)
tmax = max(cellfun(@max,texp_all)); % max time of propagation
plotname = replace(analysisname_all,' ','_'); % plot description

s0_all = {}; % Initial orbits state vector
for i = 1:length(orb_files_all)
    load(orb_files_all{i},'JC_sp','Store_sp');
    idx = ismember(string(JC_sp),string(JC0));
    s0_all = vertcat(s0_all,Store_sp(idx));
    clear JC_sp Store_sp
end

ICplotting(folder,plotname,JC0,s0exp_unique,s0_all,orb_files_all) % plot initial orbits and explosion points

twodplot(folder,plotname,texp_all,s0_all,sexp_all,orbit_debris_all,out_of_system_all,impact_moon_all,impact_earth_all) % plot snapshots of debris
twodplot_moon_explosion(folder,plotname,texp_all,s0_all,sexp_all,orbit_debris_all,out_of_system_all,impact_moon_all,impact_earth_all) % plot snapshots of debris (zoom on moon SoI)

evolutiondebrisplotting(folder,plotname,out_of_system_all,impact_earth_all,impact_moon_all,texp_all) % plot evolution of debris based on type
danger_Lpoints_plotting(folder,plotname,sexp_all,t0exp_all,tmax) % plot danger zones for L1 and L2

trajectory_plotting(folder,plotname,texp_all,s0_all,sexp_all,JC_all,orbit_debris_all,out_of_system_all,impact_moon_all,impact_earth_all) % plot short term trajectories divided by JC
density_map_plotting(folder,plotname,sexp_all) % plot debris accumulation over time

% plots of comparison for different families

% Possible plotting colors (add more RGB triplets for more than one-to-one
% comparison)
color = [0 0.4470 0.7410;
    0.9290 0.6940 0.1250];

% Create folder to store comparison plots
folder = append(codepath,'\02 plots\',foldername_all);
mkdir(append(folder,'\comparison'));

danger_Lpoints_comparison(folder,analysisname_all,color(coloridx_all,:),sexp_all,t0exp_all,tmax) % plot danger zones for L1 and L2
debris_evolution_comparison(folder,analysisname_all,color(coloridx_all,:),orbit_debris_all,out_of_system_all,impact_moon_all,impact_earth_all,texp_all)  % plot evolution of debris based on type

end
