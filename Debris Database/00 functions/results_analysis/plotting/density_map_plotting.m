%%%% FUNCTION
%
% Plotting debris accumulation over time in xy plane, 300x300 square regions
%
%%%% INPUTS %%%%
% - folder: specify folder to store plot
% - plotname: current family name
% - sexp_all: state vectors of debris [nondim]
%
%%%% OUTPUTS %%%%
% plot and png stored in folder as:
% - density_map_plotname.png
%
%   Author: Marta Lopez Castro
%   Version: July 25, 2024
%
% *********************************************************************
% Copyright 2023 - 2025 David Canales Garcia; All Rights Reserved.
% *********************************************************************

function density_map_plotting(folder,plotname,sexp_all)

% Concatenate all debris state vectors
s_concat = cat(1,sexp_all{:});

% Create and configure plot
figure('Position',[2500 -300 1280 960])  
axis equal
ax = gca;
ax.FontSize = 24;
hold on
%Side colorbar
colormap('turbo')
hcb=colorbar;
title(hcb,'Particles')

% Plot histogram of interest region with 300x300 bins and XY data
hist3(s_concat(:,1:2),'CdataMode','auto','Nbins',[300 300],'EdgeColor','flat');
h3 = hist3(s_concat(:,1:2),'CdataMode','auto','Nbins',[300 300],'EdgeColor','flat');
view(2)

xlim([-1.8 1.8])
ylim([-1.8 1.8])

% Define colorbar texts
tick_dist = round(max(h3,[],'all')/(4*1000));
hcb.Ticks = 0:tick_dist*1000:max(h3,[],'all');

xlabel('x (nondim)')
ylabel('y (nondim)')

% Save fig as .png
exportgraphics(gcf,append(folder,'\density_map_',replace(plotname,' ','_'),'.png'),'Resolution',600)
end