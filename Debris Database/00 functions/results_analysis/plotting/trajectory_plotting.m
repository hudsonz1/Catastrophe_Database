%%%% FUNCTION
%
% Plotting short term trajectories divided by JC
%
%%%% INPUTS %%%%
% - folder: specify folder to store plot
% - plotname: current family name
% - texp_all: time vectors for the state vectors [nondim]
% - s0_all: state vector of the orbits' IC [nondim]
% - sexp_all: state vectors of debris [nondim]
% - orbit_debris_all: logical indexing vector of orbiting debris [boolean]
% - out_of_system_all: logical indexing vector of escaping debris [boolean]
% - impact_moon_all: logical indexing vector of debris impacted by Moon [boolean]
% - impact_earth_all: state vectors of debris impacted by Earth [boolean]

%
%%%% OUTPUTS %%%%
% 5 plots and pngs stored in folder as:
% - trajectory_JC_plotname.png
%
%   Author: Marta Lopez Castro
%   Version: July 25, 2024
%
% *********************************************************************
% Copyright 2023 - 2025 David Canales Garcia; All Rights Reserved.
% *********************************************************************

function trajectory_plotting(folder,plotname,texp_all,s0_all,sexp_all,JC_all,orbit_debris_all,out_of_system_all,impact_moon_all,impact_earth_all)

% Load and define constants
somedata;
load('somedata.mat','*');
Lagrange_Points = lagrange;
nel = length(sexp_all);

% Find index for first particle of each explosion
[~,idx_exp,~] = unique(cell2mat(cellfun(@(x) x(1,1:3)',sexp_all,'UniformOutput',false))','rows','stable');
idx_exp(end+1) = nel+1;

% Separate in groups of JC (one is JC>2.99 as there is no restricting ZVC)
idx_ZVC = JC_all>2.99;
JC = JC_all(idx_ZVC);
ng = 4;
idx_JC_part = kmeans(JC',ng);

idx_JC = double(~idx_ZVC);
idx_JC(idx_ZVC) = idx_JC_part+1;

% Set type of debris and type colors
plottingformat = [0 0 0 0.75;
    0 1 0 0.9;
    1 0 0 0.9;
    0 0 1 0.75];
part_type = max([ones(1,nel);2*impact_earth_all;3*impact_moon_all;4*orbit_debris_all]);

% Time frame
tadim = round(30.*(3600*24/tcar),2);

% For each group of JC
for i = 1:ng+1
    % Create and configure plot
    f = figure;
    f.Position = [2050 -300 1325 1000];
    ax = gca;
    ax.FontSize = 20;

    view(2)
    hold on
    grid on
    axis equal

    xlabel('x (nondim)');
    ylabel('y (nondim)');

    % dummy and SoI plots for legend
    lg = [];
    lg(end+1) = plot(NaN,NaN,'b.','MarkerSize',24,'DisplayName','Orbiting debris');
    lg(end+1) = plot(NaN,NaN,'k.','MarkerSize',24,'DisplayName','Out of system');
    lg(end+1) = plot(NaN,NaN,'g.','MarkerSize',24,'DisplayName','Impact Earth');
    lg(end+1) = plot(NaN,NaN,'r.','MarkerSize',24,'DisplayName','Impact Moon');
    lg(end+1) = plot(NaN,NaN,'-c','LineWidth',2,'DisplayName','Initial orbits');
    lg(end+1) = plot(NaN,NaN,'*','Color',"#7E2F8E",'MarkerSize',20,'DisplayName','Lagrange points'); % lagrange point

    % Find particles in group
    for j=find(idx_JC==i)
        % Find final time (min(50 days or texp(end)))
        step = find(texp_all{j}==tadim);
        if isempty(step)
            step = length(texp_all{j});
        end
        % Plot trajectory
        plot(sexp_all{j}(1:step,1),sexp_all{j}(1:step,2),'Color',plottingformat(part_type(j),:),'LineWidth',0.3)
    end


    % Plot system objects
    DrawEarthCR3BPnondim(MU, re/lcar, re/lcar) %earth
    DrawMoonCR3BPnondim(MU,rm/lcar,rm/lcar) %moon
    plot(Lagrange_Points(:,1),Lagrange_Points(:,2),'*','MarkerSize',8,'Color',"#7E2F8E") % lagrange points
    cellfun(@(x) plot(x(:,1), x(:,2),'c','LineWidth',1), s0_all) % orbits

    % Plot ZVCs (and add legend items)
    if i>1
        lg(end+1) = plot(NaN,NaN,'-','Color',"#F4A6F8",'LineWidth',2,'DisplayName',sprintf('ZVC (JC=%0.3f)',max(JC_all(idx_JC==i))));
        ZVC_plot_xy(max(JC_all(idx_JC==i)),'#F4A6F8');
        lg(end+1) = plot(NaN,NaN,'-','Color','#E243E9','LineWidth',2,'DisplayName',sprintf('ZVC (JC=%0.3f)',min(JC_all(idx_JC==i))));
        ZVC_plot_xy(min(JC_all(idx_JC==i)),'#E243E9');
    end


    xlim([-3 3])
    ylim([-3 3])
    xticks(-3:1:3)
    yticks(-3:1:3)

    lgd = legend(lg,'Location','eastoutside');


    title(sprintf('%0.3f \\leq JC \\leq %0.3f',min(JC_all(idx_JC==i)),max(JC_all(idx_JC==i))),'interpreter','tex')

    % Save fig as .png
    exportgraphics(gcf,append(folder,'\trajectory_',sprintf('%.0f_',max(JC_all(idx_JC==i)*100)),plotname,'.png'),'Resolution',600)

end
end