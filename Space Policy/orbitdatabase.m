
codepath = fileparts(matlab.desktop.editor.getActiveFilename); 
cd(codepath);
allpaths = genpath(codepath);
addpath(genpath(codepath));

Orbits = what('orbit_families');
poss_Families = erase(Orbits.mat,'.mat');

Families = poss_Families(listdlg('PromptString',{'Select orbit families to study'},'ListString',poss_Families));
Families_files = append(Orbits.path,'\',Families,'.mat');

JClims = inputdlg({'Min Jacobi','Max Jacobi'},'Limits for Jacobi constants', [1 30; 1 30], {'2.97','3.02'}); 

answer = questdlg('Do you want to plot?', 'Plotting', 'Yes','No','No');
plotting = isequal(answer,'Yes');


Specific = what('specific_orbit_families');
desc = strcat(extractBefore(Families,2),extract(Families,digitsPattern));
desc = append(desc{:});
date = append(string(month(datetime)),'_',string(day(datetime)));
sp_dir = append(Specific.path,'\sp_orbit_',date,'_',desc);
mkdir(sp_dir);
mkdir(append(sp_dir,'\orbits'));

for j = 1:length(Families_files)
    createspecificorbitdatabase(Families_files{j},eval(JClims{1}),eval(JClims{2}),plotting);
end

%% get data

files = what(append(sp_dir,'\orbits'));
files = append(files.path,'\',files.mat);

div = 8;
IC_exp = [];
t0_exp = [];
orbs = [];
orbit_info = {};

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

idx = ismember(ceil((1:length(IC_exp))/8),orbs);
IC_exp = IC_exp(idx,:);
t0_exp = t0_exp(idx);

save(append(sp_dir,'\ICD_',desc,'_',string(length(IC_exp)),'.mat'),'IC_exp','t0_exp','orbit_info');


%% functions

function createspecificorbitdatabase(fileref,JCmin,JCmax,plotting)

% Output Criteria
div = 8; % number of IC

% Read in all the possible initial conditions
[MU, Period, ICDatabase] = DataBaseOrbitInfo(fileref);
options=odeset('RelTol',1e-12,'AbsTol',1e-12);

%family
[~,family,~] = fileparts(fileref);
IC_t = (1:div)./div;
JC = zeros(length(Period),1);
IC_explosion = [];
t0 = [];
orbit_info_all = {};

for ii = 1:length(Period)
    tf = IC_t*Period(ii);
    tspan = horzcat(zeros(8,1),round(tf,2)');
    s0 = ICDatabase(ii,:)';
    JC(ii) = CR3BP_JC(s0, MU);
    if (JC(ii)>JCmin)*(JC(ii)<JCmax)
        for jj = 1:length(IC_t)
            [~, State] = ode45(@(t,x) CR3BP_alt(t, x, MU, 1), tspan(jj,:), s0, options);
            t0(end+1) = tspan(jj,2);
            IC_explosion(end+1,:) = State(end,:);
            orbit_info_all{end+1} = sprintf('%s orbit with JC = %d at t0 = %d', family,JC(ii),t0(end));
        end
    else
        [~, State] = ode45(@(t,x) CR3BP_alt(t, x, MU, 1), tspan(end,:), s0, options);
    end
    Store{ii,1} = State(:,1:3);
end

%specific orbit
idx = find((JC>JCmin).*(JC<JCmax));
ICDatabase_sp = ICDatabase(idx,:);
s_sp = State(idx,:);
Period_sp = Period(idx,:);
Store_sp = Store(idx,:);
JC_sp = JC(idx,:);

[~,family,~] = fileparts(fileref);
filepath = append(evalin('caller','sp_dir'),'\orbits\');

databasecreate(["JC_sp","Period_sp","IC_explosion","t0","orbit_info_all"],append(filepath,'specific_',family));


if plotting~=0    
   orbitdatabase_plotting
end

end

function [MU, Period, IC] = DataBaseOrbitInfo(FamilyFileName)
% Brian Baker-McEvilly
% modified by Marta Lopez Castro
% This function reads the initial conditions and the last time entry, which
% is assumed to be at one period, in the database files of orbit families
%
% Input:
%   FamilyFileName: Name of the .mat file with the orbit family info
%                   Ex. 'Axial_L1.mat'
% Output:
%   MU: the used mass parameter of the CR3BP system
%   Period: the periods of the corresponding orbits
%   IC: the initial conditions of the corresponding orbits
%

Familydata = struct2cell(load(FamilyFileName)); % load in database

MU = Familydata{2,1}.massRatio;
for ii = 1:length(Familydata{4,1})
    Period(ii,1) = Familydata{5}{ii}(end,1);
    IC(ii,1:6) = Familydata{4}{ii}(1,1:6);
end

end

