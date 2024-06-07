%%%% FUNCTION
%
% Plotting the comparison of danger points for short and long term
%
%%%% INPUTS %%%%
% - folder: specify folder to store plot
% - plotname: current family name
% - color: color of current family
% - s: state vectors [nondim]
% - t0: time of first explosion [nondim]
% - tmax: final time of propagation [nondim]
%
%%%% OUTPUTS %%%%
% plot and png stored in folder as:
% - danger_comparison_short.png
% - danger_comparison_long.png
%
%   Author: Marta Lopez Castro
%   Version: June 04, 2024
%
% *********************************************************************
% Copyright 2023 - 2025 David Canales Garcia; All Rights Reserved.
% *********************************************************************

function  danger_Lpoints_comparison(folder,plotname,color,s,t0,tmax)

% Set current folder
folder = append(folder,'\comparison\');

cd(folder)

% Load constants
somedata;
load('somedata.mat','lcar','tcar');

% Define variables
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

% Long term
% Check if any family data is stored, if so open it to overwrite new data
if ~isempty(ls('*danger_comparison_long.*'))
    open('danger_comparison_long.fig')
else
    figure
    hold on
end

% L1 plot
subplot(2,1,1)
legend
hold on
grid on
title('Danger Zone at L1 (10,000 km)')
plot(time(time>shortt),smooth(isdangerL1(time>shortt)),'DisplayName',plotname,'Color',color)
xlabel('time (days)')
ylabel('number of particles')

% L2 plot
subplot(2,1,2)
legend
hold on
grid on
title('Danger Zone at L2 (10,000 km)')
plot(time(time>shortt),smooth(isdangerL2(time>shortt)),'DisplayName',plotname,'Color',color)
xlabel('time (days)')
ylabel('number of particles')

fontsize(16,"points")
f = gcf;
f.Position = [2700,-120,920,650];

% Save fig and png
saveas(f,append(folder,'\danger_comparison_long.fig'))
exportgraphics(f,append(folder,'\danger_comparison_long.png'),'Resolution',600)

% Repeat for Short term
if ~isempty(ls('*danger_comparison_short.*'))
    open('danger_comparison_short.fig')
else
    figure
    hold on
end

subplot(2,1,1)
legend
hold on
grid on
title('Danger Zone at L1 (10,000 km)')
plot(time(time<shortt),smooth(isdangerL1(time<shortt)),'DisplayName',plotname,'Color',color)
xlabel('time (days)')
ylabel('number of particles')


subplot(2,1,2)
legend
hold on
grid on
title('Danger Zone at L2 (10,000 km)')
plot(time(time<shortt),smooth(isdangerL2(time<shortt)),'DisplayName',plotname,'Color',color)
xlabel('time (days)')
ylabel('number of particles')

fontsize(18,"points")
f = gcf;
f.Position = [2700,-120,920,650];

saveas(f,append(folder,'\danger_comparison_short.fig'))
exportgraphics(f,append(folder,'\danger_comparison_short.png'),'Resolution',600)

end