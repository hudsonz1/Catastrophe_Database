%% Explosion Database
clear all; clc; close all
%tic

% find code folder
codepath = fileparts(matlab.desktop.editor.getActiveFilename); 
cd(codepath);
% add paths
allpaths = genpath(codepath);
addpath(genpath(codepath));


%% Prev data
somedata;
load('somedata.mat','*');

% Lagrange Points
Lagrange_Points = lagrange;

% Initial Conditions satellite
msat = 1457;

% Initial Conditions for satellite orbit
% [orbitset,orbitpath] = uigetfile(append(cd,'\01 orbits\specific_orbit_families'));
% load(append(orbitpath,orbitset),'*');
load('DRO3data.mat');

%propagation time
evol_t_options = {"50 days", "6 months", "1 year", "2 years","other"};
evol_t_idx = listdlg("PromptString",{'Select propagation time'},"SelectionMode","single","ListString",evol_t_options);

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

for orbitpick = 1:1

IC_exp = DRO3.initialnodes{orbitpick};

% explosionpath = append(orbitpath,'explosions');
explosionpath = "C:\Users\blade\Documents\ERAU\ERAU RESEARCH\BOOM WORK\new matlab codes\01 orbits\specific_orbit_families\sp_orbit_4_8_DRO3\explosions";
mkdir(explosionpath);

no = length(IC_exp); % should always be 200

%%

wb = waitbar(0,'Starting ...');
pause(0.1);

    for sat = 1:no

    waitbar((sat-1)/no,wb, sprintf('Calculating velocities of orbit %d/%d', sat, no));
    %% Catastrophic Mishap
    % NASA BM
    lcmin = 0.11; % in m

    % Change in velocity
    vpm = NASA_BM_EVOLVE4(msat,lcmin); % deltav
    vpm = vpm./(vcar*1000); % deltav nondim

    nel = size(vpm,2);

    vpx = 2.*rand(nel,1) - 1;
    vpy = 2.*rand(nel,1) - 1;
    vpz = 2.*rand(nel,1) - 1;

    vdir = [vpx, vpy, vpz];

    vp = vpm'.*vdir./vecnorm(vdir,2,2);

    vp_norm = vecnorm(vp,2,2);
    avg = sum(vp_norm)/nel;

    vp_dim = vp.*(vcar*1000);

    figure
    view(3)
    grid on
    axis equal
    xlabel('$\dot x$ (m/s)','Interpreter','latex');
    ylabel('$\dot y$ (m/s)','Interpreter','latex');
    zlabel('$\dot z$ (m/s)','Interpreter','latex');
    xlim([-400 400])
    ylim([-400 400])
    zlim([-400 400])
    hold on
    for i = 1:nel 
    plot3([0 vp_dim(i,1)],[0 vp_dim(i,2)], [0 vp_dim(i,3)])   
    end

    %% Explosion

    ICexp = IC_exp(sat,:);
%     [s0exp, texp, sexp] = explosion(ICexp,t0_exp(i),evol_t,vp,{wb,i,no});
    [s0exp, texp, sexp] = explosion(ICexp,0,evol_t,vp,{wb,sat,no});

    %% Jacobi Constant
    waitbar(sat/no,wb, sprintf('Calculating Jacobi constants of orbit %d/%d', sat, no));
    JC = jacobiconstant(MU,nel,sexp);

    %% Class of debris
    waitbar(sat/no,wb, sprintf('Calculating results of orbit %d/%d', sat, no));
    [orbit_debris, impact_moon, impact_earth, out_of_system] = classofdebris(texp,sexp,rsoie_2BP,rm_star,re_star,r_moon,r_earth);

    %% Store data

    waitbar(sat/no,wb, sprintf('Storing data %d/%d', sat, no));
%     orbit_data = split(orbit_info(sat));
%     desc = strcat(extractBefore(orbit_data(1),2),extract(orbit_data(1),digitsPattern));
%     desc = append(desc{:});
%     filename = append(replace(append('explosion_',desc,'_',string(eval(orbit_data{6})),'_',string(eval(orbit_data{10})),'_',string(nel)),'.','-'),'.mat');
    filename = append('explosion_DRO3_sat_',num2str(sat),'_orbit_',num2str(orbitpick),'.mat');
    databasecreate(["s0exp", "texp", "sexp", "JC", "orbit_debris", "impact_moon", "impact_earth", "out_of_system","ICexp"],append(explosionpath,'\',filename));
    

    end

end

close(wb)