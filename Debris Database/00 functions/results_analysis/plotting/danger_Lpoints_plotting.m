%%%% FUNCTION
%
% Plotting of Danger points for short and long term
%
%%%% INPUTS %%%%
% - folder: specify folder to store plot
% - plotname: file description
% - s: state vectors [nondim]
% - t0: time of first explosion [nondim]
% - tmax: final time of propagation [nondim]
%
%%%% OUTPUTS %%%%
% plot and png stored in folder as:
% - danger_short_plotname.png
% - danger_long_plotname.png
%
%   Author: Marta Lopez Castro
%   Version: June 04, 2024
%
% *********************************************************************
% Copyright 2023 - 2025 David Canales Garcia; All Rights Reserved.
% *********************************************************************


function  danger_Lpoints_plotting(folder,plotname,s,t0,tmax)

% Load constants
somedata;
load('somedata.mat','lcar','tcar');

% Define variables
tmin = min(t0); % First time step of esplosions
timesteps = round(tmax*100+1); % number of time steps
nel = size(s,2); % number of particles
L = lagrange; % Lagrange points
danger = 10000/lcar; % danger zone radius
pos = [L(1,:) 0]; % danger Zone center (L1)
shortt = 50; % time of short term

% Initialize variables
isdangermat = zeros(timesteps,nel);

for i = 1:nel
    % Define t0 in global time
    vecstart = int64(t0(i)*100+1);
    % Find if particle inside Danger Zone for each time
    partdanger = vecnorm(s{i}(:,1:3)-pos,2,2)<danger;
    % Save in global array
    isdangermat(vecstart:vecstart+length(partdanger)-1,i) = partdanger;
end

% Number of particles inside danger zone for each time step
isdangerL1 = sum(isdangermat,2);

% Repeat for L2
 
pos = [L(2,:) 0];

isdangermat = zeros(timesteps,nel);

for i = 1:nel
    vecstart = int64(t0(i)*100+1);
    partdanger = vecnorm(s{i}(:,1:3)-pos,2,2)<danger;
    isdangermat(vecstart:vecstart+length(partdanger)-1,i) = partdanger;
end

isdangerL2 = sum(isdangermat,2);

time = (0:1:timesteps-1)*(tcar/100)/(3600*24);

% Short term figure
f = tiledlayout('vertical');

%title(f,'Danger zones (10000 km) of Lagrange points')
% L1 Danger Zone
nexttile
grid on
plot(time,smooth(isdangerL1),'Color',[0 0.4470 0.7410])
xlabel('time (days)')
ylabel('number of particles')
legend('L1 Danger Zone')

% L2 Danger Zone
nexttile
grid on
plot(time,smooth(isdangerL2),'Color',[0.9290 0.6940 0.1250])
xlabel('time (days)')
ylabel('number of particles')
legend('L2 Danger Zone')

%save fig in .png
exportgraphics(f,append(folder,'\danger_long_',plotname,'.png'),'Resolution',600)

% Long term figure
f2 = tiledlayout('vertical');

title(f2,'Danger zones (10000 km) of Lagrange points')

nexttile
grid on
plot(time(time<shortt),smooth(isdangerL1(time<shortt)),'Color',[0 0.4470 0.7410])
xlabel('time (days)')
ylabel('Number of particles')
legend('L1 Danger Zone')


nexttile
grid on
plot(time(time<shortt),smooth(isdangerL2(time<shortt)),'Color',[0.9290 0.6940 0.1250])
xlabel('Time (days)')
ylabel('Number of particles')
legend('L2 Danger Zone')

exportgraphics(f2,append(folder,'\danger_short_',plotname,'.png'),'Resolution',600)

end