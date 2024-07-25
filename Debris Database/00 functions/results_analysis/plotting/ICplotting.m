%%%% FUNCTION
%
% Plotting initial conditions of the break-up events
%
%%%% INPUTS %%%%
% - folder: specify folder to store plot
% - plotname: name of the family orbit
% - JC0: Initial Jacobi constants [nondim]
% - s0: initial debris state vectors (where the explosions occur) [nondim]
% - Store: initial orbits state vectors [nondim]
% - orb_files_all: files containing specific orbits' IC [nondim]
%
%%%% OUTPUTS %%%%
% plot and png stored in folder as:
% - initial_conditions_plotname.png
%
%   Author: Marta Lopez Castro
%   Version: July 25, 2024
%
% *********************************************************************
% Copyright 2023 - 2025 David Canales Garcia; All Rights Reserved.
% *********************************************************************

function ICplotting(folder,plotname,JC0,s0,Store,orb_files_all)

% Load constants
load('somedata.mat','lcar','MU','rsoi_moon','r_moon');

% Figure
figure   %('WindowState','maximized')
cmap=parula(length(JC0));
hold on;
grid on;
axis equal;
hcb=colorbar;
set(gca,'colororder',cmap,'colormap',cmap)
set(gcf,'color','w')
clim([min(JC0)-0.001 max(JC0)+0.001]);
title(hcb,'JC')

map = [flipud(cool)];

xlabel('x (nondim)','FontSize',12);
ylabel('y (nondim)','FontSize',12);

xlim padded
ylim padded

colormap(map)

% Plot orbits, color according to JC
for ii = 1:length(JC0)
    Csurf = ones(length(Store{ii,1}(:,1)),1)*JC0(ii);
    surf([Store{ii,1}(:,1) Store{ii,1}(:,1) Store{ii,1}(:,1)], [Store{ii,1}(:,2) Store{ii,1}(:,2) Store{ii,1}(:,2)],...
        [Store{ii,1}(:,3) Store{ii,1}(:,3) Store{ii,1}(:,3)], [Csurf Csurf Csurf],'EdgeColor','interp','Linewidth',1);
end

% Plot system objects
title('Pre-Break Up Event')
DrawMoonCR3BPnondim(MU, 1741/lcar, 1741/lcar) % Moon
text(r_moon(1),r_moon(2),' Moon')

plot(0.836915127902534,0, '.','MarkerSize',10, 'Color',"#7E2F8E") % L1
text(0.836915127902534,0,' L_1', 'Color',"#7E2F8E")

plot(1.15568216540787, 0, '.','MarkerSize',10, 'Color',"#7E2F8E") % L2
text(1.15568216540787,0,' L_2', 'Color',"#7E2F8E")

circle(1-MU,0,rsoi_moon,"#EDB120"); % rsoi
text(r_moon(1)+rsoi_moon/sqrt(2),r_moon(2)+rsoi_moon/sqrt(2),'\leftarrow SOI_{ Moon}')

plot(s0(:,1),s0(:,2),'.r') % IC

xlims = xlim;
xticks(round(xlims(1),1)-0.2:0.2:round(xlims(2),1)+0.2)
ylims = ylim;
yticks(round(ylims(1),1)-0.2:0.2:round(ylims(2),1)+0.2)

% Save fig as .png
exportgraphics(gcf,append(folder,'\initial_conditions_',plotname,'.png'),'Resolution',600)

end