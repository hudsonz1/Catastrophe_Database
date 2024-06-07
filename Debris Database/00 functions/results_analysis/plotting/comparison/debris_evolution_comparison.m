%%%% FUNCTION
%
% Plotting the comparison of debris evolution for different families
%
%%%% INPUTS %%%%
% - folder: specify folder to store plot
% - plotname: current family name
% - color: color of current family
% - orbit_debris_all: logical indexing vector of orbiting debris [boolean]
% - out_of_system_all: logical indexing vector of escaping debris [boolean]
% - impact_moon_all: logical indexing vector of debris impacted by Moon [boolean]
% - impact_earth_all: state vectors of debris impacted by Earth [boolean]
% - texp_all: time vectors for the state vectors [nondim]
%
%%%% OUTPUTS %%%%
% plot and png stored in folder as:
% - evolution_comp.png
%
%   Author: Marta Lopez Castro
%   Version: June 04, 2024
%
% *********************************************************************
% Copyright 2023 - 2025 David Canales Garcia; All Rights Reserved.
% *********************************************************************

function debris_evolution_comparison(folder,plotname,color,orbit_debris_all,out_of_system_all,impact_moon_all,impact_earth_all,texp_all)

% Set current folder
folder = append(folder,'\comparison\');
cd(folder)

% Check if any family data is stored, if so load data
try
    load(append(folder,'\evol_deb.mat'),'data_short','data_long','plotnames','colors')
catch
    data_short = [];
    data_long = [];
    plotnames = char;
    colors = [];
end

% Load constant
load('somedata.mat','tcar');

% Define variables
shortt = 3600*24*50/tcar; % Short term time
nel = length(texp_all); % Number of particles
% Find the time steps when particle
time_out = cellfun(@(x) x(end), texp_all(logical(out_of_system_all))); % Out of system
time_earth = cellfun(@(x) x(end), texp_all(logical(impact_earth_all))); % Impact Earth
time_moon = cellfun(@(x) x(end), texp_all(logical(impact_moon_all))); % Impact Moon

% Particle types for short term (sum of each type)
data_short(1:3,end+1) = [sum(time_earth<shortt);sum(time_moon<shortt);sum(time_out<shortt)].*(100/nel);
data_short(4,end) = 100-sum(data_short(1:3,end));
% Particle types for long term 
data_long(1:4,end+1) = [sum(impact_earth_all);sum(impact_moon_all);sum(out_of_system_all);sum(orbit_debris_all)].*(100/nel);

%Plot parameters for each family
plotnames(end+1,:) = plotname;
colors(1:3,end+1) = color;

% Save data (append to existing)
save(append(folder,'\evol_deb.mat'),'data_short','data_long','plotnames','colors')

% Plot data
axis_labels = categorical({'Impact Earth','Impact Moon','Out of system','Orbiting debris'});
axis_labels = reordercats(axis_labels,{'Impact Earth','Impact Moon','Out of system','Orbiting debris'});

% Short term figure
f = figure;
subplot(2,1,1)
% Plot bars
b = barh(axis_labels,data_short);
% Text (percentage of each bar) 
for i = 1:size(colors,2)
    xtips = b(i).XEndPoints;
    ytips = b(i).YEndPoints;
    labels = append(string(round(b(i).YData,2)),' %');
    text(ytips,xtips,labels,'HorizontalAlignment','left','VerticalAlignment','middle')
    b(i).FaceColor = colors(:,i);
end
legend(plotnames,'Location','Southeast')
xlabel('% of particles')
xlim([0 100])
title('Short Term Comparison')

fontsize(16,"points")
  
% Long term
subplot(2,1,2)
b = barh(axis_labels,data_long);
for i = 1:size(colors,2)
    xtips = b(i).XEndPoints;
    ytips = b(i).YEndPoints;
    labels = append(string(round(b(i).YData,2)),' %');
    text(ytips,xtips,labels,'HorizontalAlignment','left','VerticalAlignment','middle')
    b(i).FaceColor = colors(:,i);
end
legend(plotnames,'Location','Southeast')
xlabel('% of particles')
xlim([0 100])
title('Long Term Comparison')
fontsize(16,"points")

f.Position = [2350	-250	1150	800];

% Save plot .png
exportgraphics(gcf,append(folder,'\evolution_comp.png'),'Resolution',600)

end