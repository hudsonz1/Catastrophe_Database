%% Generating specific orbit database
%
% First step for the debris generation. 
% User is required to define inputs
% that define which orbits are studied.
%
% Run of codes requires strict folder structure to work
% as defined in GitHub readme
% Automatically load and add path of inputs and functions
%
%%%% SEQUENCE
% - Run
% - Input 1: select one or more families of interest
% - Input 2: range of Jacobi constants
% - Input 3: yes/no plot orbit family (optional)
% - Extraction of data
% - Input 4: number of orbits to be stored
%
%%%% OUTPUT
% - sp_orbit_MM_DD_Family folder that includes the specific IC
%   (\01 orbits\specific_orbit_families)
% - ICD_Family_n.mat, stores the necessary IC data
%   (\01 orbits\specific_orbit_families\sp_orbit_MM_DD_Family)
%
%%%% REQUIRED USER FUNCTIONS
% - createspecificorbitdatabase (\00 functions\data_management)
% - databasecreate (\00 functions\data_management)
% - cr3bp (\00 functions\dynamic_model)
%
%   Author: Marta Lopez Castro
%   Version: June 04, 2024
 
% *********************************************************************
% Copyright 2023 - 2025 David Canales Garcia; All Rights Reserved.
% *********************************************************************

%% Orbit database

% Code paths
codepath = fileparts(matlab.desktop.editor.getActiveFilename); 
cd(codepath);
allpaths = genpath(codepath);
addpath(genpath(codepath));

% Read possible family orbits
Orbits = what('orbit_families');
poss_Families = erase(Orbits.mat,'.mat');

% Selecting the family orbit
Families = poss_Families(listdlg('PromptString',{'Select orbit families to study'},'ListString',poss_Families));
Families_files = append(Orbits.path,'\',Families,'.mat');

% Range of Jacobi Constant
JClims = inputdlg({'Min Jacobi','Max Jacobi'},'Limits for Jacobi constants', [1 30; 1 30], {'2.97','3.02'}); 

% Orbits' plot
answer = questdlg('Do you want to plot?', 'Plotting', 'Yes','No','No');
plotting = isequal(answer,'Yes');

% Creation of new folders to save the specific initial conditions
Specific = what('specific_orbit_families');
desc = strcat(extractBefore(Families,2),extract(Families,digitsPattern));
desc = append(desc{:});
date = append(string(month(datetime)),'_',string(day(datetime)));
sp_dir = append(Specific.path,'\sp_orbit_',date,'_',desc);
mkdir(sp_dir);
mkdir(append(sp_dir,'\orbits'));

% Number of explosions per orbit
div = eval(cell2mat(inputdlg({'Segments'},'Number of explosions per orbit', [1 30], {'8'}))); 
%div = 8;

% Creation of the orbit database
for j = 1:length(Families_files)
    createspecificorbitdatabase(Families_files{j},eval(JClims{1}),eval(JClims{2}),plotting,div);
end

% get data about the available orbits
files = what(append(sp_dir,'\orbits'));
files = append(files.path,'\',files.mat);


% Initializing variables
IC_exp = [];
t0_exp = [];
orbs = [];
orbit_info = {};

% Selecting initial conditions to save
for i = 1:length(files)
    load(files{i},'IC_explosion','t0','orbit_info_all');
    no = length(IC_explosion)/div;
    if no>0
    orbs_sel = 1:no;
    orbs_sel = orbs_sel(listdlg('PromptString',{append('Select ',Families{i},' orbits to store')},'ListString',string(orbs_sel)));
    orbs = horzcat(orbs,orbs_sel+length(IC_exp)/div);
    IC_exp = vertcat(IC_exp,IC_explosion);
    t0_exp = vertcat(t0_exp,t0');
    orbit_info = horzcat(orbit_info,orbit_info_all);
    end
end

% Saving initial conditions based on user selections
idx = ismember(ceil((1:length(IC_exp))/div),orbs);
IC_exp = IC_exp(idx,:);
t0_exp = t0_exp(idx);
orbit_info_exp = orbit_info(idx);

save(append(sp_dir,'\ICD_',desc,'_',string(length(IC_exp)),'.mat'),'IC_exp','t0_exp','orbit_info_exp'); % ORBIT DATABASE
