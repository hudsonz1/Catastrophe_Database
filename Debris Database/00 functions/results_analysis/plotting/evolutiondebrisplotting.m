%%%% FUNCTION
%
% Plotting debris evolution
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
% - evolution_plotname.png
%
%   Author: Marta Lopez Castro
%   Version: June 04, 2024
%
% *********************************************************************
% Copyright 2023 - 2025 David Canales Garcia; All Rights Reserved.
% *********************************************************************

function evolutiondebrisplotting(folder,plotname,out_of_system_all,impact_earth_all,impact_moon_all,texp_all)

% Load constants
load('somedata.mat','tcar');

% Define variables
nel = length(texp_all); % Number of particles
% Index of time step when particles
idx_out = cellfun(@length, texp_all(logical(out_of_system_all))); % Out of system
idx_earth = cellfun(@length, texp_all(logical(impact_earth_all))); % Impact Earth
idx_moon = cellfun(@length, texp_all(logical(impact_moon_all))); % Impact Moon
max_idx = max(cellfun(@length, texp_all)); % Last time step of propagation
idx_max = find(cellfun(@length, texp_all)==max_idx,1);

% Accum sum of particles accomplising each condition
for i = 1:max_idx
    accum_impactmoon(i) = sum(idx_moon<i);
    accum_impactearth(i) = sum(idx_earth<i);
    accum_out(i) = sum(idx_out<i);
    
end
accum_orbiting = nel - accum_impactmoon - accum_impactearth - accum_out;

% Figure
figure  
hold on
grid on
plot(texp_all{idx_max}.*(tcar/(3600*24*365/12)), accum_out,texp_all{idx_max}.*(tcar/(3600*24*365/12)), ...
    accum_impactmoon,texp_all{idx_max}.*(tcar/(3600*24*365/12)), accum_orbiting,texp_all{idx_max}.*(tcar/(3600*24*365/12)), accum_impactearth,'-','LineWidth',1.5)
legend('Out of system','Impact Moon','Orbiting debris','Impact Earth')
ylabel('number of particles')
xlabel('time (months)')

% Save fig as .png
exportgraphics(gcf,append(folder,'\evolution_',plotname,'.png'),'Resolution',600)

end