%%%% FUNCTION
%
% Plotting orbits
%
%%%% INPUTS %%%%
% - folder: specify folder to store plot
% - plotname: name of the family orbit
% - JC: Jacobi constant [nondim]
% - Store: state vector of the initial conditions [nondim]
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

function ICplottingfromorbitdatabase(folder,plotname,JC,Store)

% Load constants
load('somedata.mat','lcar','MU','rsoi_moon','r_moon','rm','r_earth','re');

% Figure plot, define plot plot characteristics
figure('Position',[2500 -300 1280 960])  
cmap=parula(length(JC));
hold on;
grid on;
axis equal;
hcb=colorbar;
set(gca,'colororder',cmap,'colormap',cmap)
set(gcf,'color','w')
title(hcb,'JC')
clim([min(JC)-0.001 max(JC)+0.001]);

map = [flipud(cool)];

xlabel('x (nondim)','FontSize',16);
ylabel('y (nondim)','FontSize',16);

xlim padded
ylim padded

colormap(map)

% Plot orbits, color according to JC
for ii = 1:4:length(Store)
    Csurf = ones(length(Store{ii,1}(:,1)),1)*JC(ii);
    surf([Store{ii,1}(:,1) Store{ii,1}(:,1) Store{ii,1}(:,1)], [Store{ii,1}(:,2) Store{ii,1}(:,2) Store{ii,1}(:,2)],...
        [Store{ii,1}(:,3) Store{ii,1}(:,3) Store{ii,1}(:,3)], [Csurf Csurf Csurf],'EdgeColor','interp','Linewidth',1);
end

ax = gca;
ax.FontSize = 14;

% Plot system objects
DrawEarthCR3BPnondim(MU, re/lcar, re/lcar) % Earth
text(r_earth(1),r_earth(2),'Earth     ','HorizontalAlignment','right')

DrawMoonCR3BPnondim(MU, rm/lcar, rm/lcar) % Moon
text(r_moon(1),r_moon(2),' Moon')

plot(0.836915127902534,0, '.','MarkerSize',10, 'Color',"#7E2F8E") % L1
text(0.836915127902534,0,' L_1', 'Color',"#7E2F8E")

plot(1.15568216540787, 0, '.','MarkerSize',10, 'Color',"#7E2F8E") % L2
text(1.15568216540787,0,' L_2', 'Color',"#7E2F8E")

circle(1-MU,0,rsoi_moon,"#EDB120"); % SoI Moon
text(r_moon(1)+rsoi_moon/sqrt(2),r_moon(2)+rsoi_moon/sqrt(2),'\leftarrow SOI_{ Moon}','FontSize',13) % SoI Moon text
%text(r_moon(1)-rsoi_moon,r_moon(2),' SOI_{ Moon} \rightarrow','HorizontalAlignment','right','FontSize',13)

% axis
xlims = xlim;
xticks(round(xlims(1),1)-0.2:0.2:round(xlims(2),1)+0.2)
ylims = ylim;
yticks(round(ylims(1),1)-0.2:0.2:round(ylims(2),1)+0.2)

% save plot as .png
exportgraphics(gcf,append(folder,'\family_',replace(plotname,' ','_'),'.png'),'Resolution',600)

end