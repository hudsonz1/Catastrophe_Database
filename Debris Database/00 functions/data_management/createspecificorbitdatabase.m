%%%% FUNCTION
%
% Storing the initial conditions of the selected orbits
%
%%%% INPUTS %%%%
% - fileref: family orbit .mat file selected
% - JCmin and JCmax: limits of the Jacobi Constant range selected [nondim]
% - plotting: 0 or 1 (no/yes)
%
%%%% OUTPUTS %%%%
% - sp_orbit_MM_DD_Family folder that includes the specific IC
% - specific_Family.mat, stored in: 
%   \01 orbits\specific_orbit_families\sp_orbit_MM_DD_Family\orbits
%
%   Author: Marta Lopez Castro
%   Version: June 04, 2024
%
% *********************************************************************
% Copyright 2023 - 2025 David Canales Garcia; All Rights Reserved.
% *********************************************************************

function createspecificorbitdatabase(fileref,JCmin,JCmax,plotting,div)

% Read in all the possible initial conditions
load(fileref,'MU','Period','IC');
options=odeset('RelTol',1e-12,'AbsTol',1e-12);

% Family
[~,family,~] = fileparts(fileref);

% Initializing variables
IC_t = (1:div)./div;
JC = zeros(length(Period),1);
IC_explosion = [];
t0 = [];
orbit_info_all = {};

% For each available initial conditions
for ii = 1:length(Period)
    % Creation of the necessary variables to propagate the ode45
    tf = IC_t*Period(ii);
    tspan = horzcat(zeros(8,1),round(tf,2)');
    s0 = IC(ii,:)';
    JC(ii) = JC_CR3BP(s0, MU);
    % Is JC in the range?
    if (JC(ii)>JCmin)*(JC(ii)<JCmax)
        for jj = 1:length(IC_t)
            [~, State] = ode45(@(t,x) cr3bp(t, x, MU, 1), tspan(jj,:), s0, options);
            t0(end+1) = tspan(jj,2);
            IC_explosion(end+1,:) = State(end,:);
            orbit_info_all{end+1} = sprintf('%s orbit with JC = %d at t0 = %d', family,JC(ii),t0(end));
        end
    else
        [~, State] = ode45(@(t,x) cr3bp(t, x, MU, 1), tspan(end,:), s0, options);
    end 
    Store{ii,1} = State(:,1:3);
end

% Specific orbit
idx = find((JC>JCmin).*(JC<JCmax));
ICDatabase_sp = IC(idx,:);
s_sp = State(idx,:);
Period_sp = Period(idx,:);
Store_sp = Store(idx,:);
JC_sp = JC(idx,:);

% Path of the new folder (sp_orbit_MM_DD_Family)
[~,family,~] = fileparts(fileref);
filepath = append(evalin('caller','sp_dir'),'\orbits\');

% Creation of the specific_Family.mat file
databasecreate(["JC_sp","Period_sp","IC_explosion","t0","orbit_info_all","Store_sp"],append(filepath,'specific_',family));


if plotting~=0
   folder = extractBefore(filepath,"\" + wildcardPattern("Except","\") + textBoundary);
   plotname = replace(erase(extractAfter(fileref,'orbit_families\'),'.mat'),'_',' ');
   ICplottingfromorbitdatabase(folder,plotname,JC,Store)
end

end
