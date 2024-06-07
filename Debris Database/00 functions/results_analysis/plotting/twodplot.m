%%%% FUNCTION
%
% Plotting the debris snapshots for different time steps
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
% plot and png stored in folder as:
% - 2Dshort_plotname.png
% - 2Dlong_plotname.png
%
%   Author: Marta Lopez Castro
%   Version: June 04, 2024
%
% *********************************************************************
% Copyright 2023 - 2025 David Canales Garcia; All Rights Reserved.
% *********************************************************************

function twodplot(folder,plotname,texp_all,s0_all,sexp_all,orbit_debris_all,out_of_system_all,impact_moon_all,impact_earth_all)

% Load constants
somedata;
load('somedata.mat','*');
Lagrange_Points = lagrange;

% Short term figure

f = figure;
tiledlayout(2,2,"TileSpacing","tight");
f.Position = [2050 -300 1130 1000];

view(2)
hold on
grid on

% Define variables
tsecs = [5, 10, 30, 50].*(3600*24); % time steps for snapshot in seconds
tdays = round(tsecs./(3600*24)); % time steps in days
tmonths = round(tsecs./(3600*24*30)); % time steps in months
tadim = round(tsecs./tcar,2); % time steps nondim
tmin = cellfun(@min,texp_all); % first explosion time step

for i = 1:length(tadim)

    subp = nexttile;
    subp.FontSize = 16;

    view(2)

    hold on
    grid on

    if tdays(i)<60
        title(sprintf('t = %s (%s %s)',string(tadim(i)),string(tdays(i)),'days'))
    else
        title(sprintf('t = %s (%s %s)',string(tadim(i)),string(tmonths(i)),'months'))
    end

    axis equal

    xlabel('x (nondim)');
    ylabel('y (nondim)');

    % Plot system objects
    circle(r_earth(1),r_earth(2),rsoie_2BP,"#D95319"); %soi earth
    DrawEarthCR3BPnondim(MU, re/lcar, re/lcar) %earth
    circle(r_moon(1),r_moon(2),rsoi_moon,"#EDB120"); %soi moon
    DrawMoonCR3BPnondim(MU,rm/lcar,rm/lcar) %moon
    plot(Lagrange_Points(:,1),Lagrange_Points(:,2),'*','MarkerSize',8,'Color',"#7E2F8E") % lagrange points
    cellfun(@(x) plot(x(:,1), x(:,2),'c','LineWidth',1), s0_all) % orbits

    %dummy plots for legend
    lg(1) = plot(NaN,NaN,'b.','MarkerSize',24,'DisplayName','Orbiting debris');
    lg(2) = plot(NaN,NaN,'k.','MarkerSize',24,'DisplayName','Out of system');
    lg(3) = plot(NaN,NaN,'g.','MarkerSize',24,'DisplayName','Impact Earth');
    lg(4) = plot(NaN,NaN,'r.','MarkerSize',24,'DisplayName','Impact Moon');
    lg(5) = plot(NaN,NaN,'-c','LineWidth',2,'DisplayName','Initial orbits');
    lg(6) = plot(NaN,NaN,'-','Color',"#D95319",'LineWidth',2,'DisplayName','SoI Earth'); %soi earth
    lg(7) = plot(NaN,NaN,'-','Color',"#EDB120",'LineWidth',2,'DisplayName','SoI Moon'); %soi moon
    lg(8) = plot(NaN,NaN,'*','Color',"#7E2F8E",'MarkerSize',20,'DisplayName','Lagrange points'); % lagrange point

    % plot debris on different style according to its type
    idxcell = cellfun(@(x) abs(x-tadim(i))<0.001, texp_all, 'UniformOutput', false);
    for j=1:length(texp_all)
        if tmin(j)<=tadim(i)
            if ~any(idxcell{j})
                if out_of_system_all(j)
                    plot(sexp_all{j}(end,1), sexp_all{j}(end,2),'k.','MarkerSize',2)
                elseif impact_moon_all(j)
                    plot(sexp_all{j}(end,1), sexp_all{j}(end,2),'r.','MarkerSize',2)
                else
                    plot(sexp_all{j}(end,1), sexp_all{j}(end,2),'g.','MarkerSize',2)
                end
            else
                if orbit_debris_all(j)
                    plot(sexp_all{j}(idxcell{j},1), sexp_all{j}(idxcell{j},2),'b.','MarkerSize',3)
                elseif out_of_system_all(j)
                    plot(sexp_all{j}(idxcell{j},1), sexp_all{j}(idxcell{j},2),'k.','MarkerSize',3)
                elseif impact_moon_all(j)
                    plot(sexp_all{j}(idxcell{j},1), sexp_all{j}(idxcell{j},2),'r.','MarkerSize',3)
                else
                    plot(sexp_all{j}(idxcell{j},1), sexp_all{j}(idxcell{j},2),'g.','MarkerSize',3)
                end
            end
        end
    end

    if i>2
        xlim([-3 3])
        ylim([-3 3])
        xticks(-3:1:3)
        yticks(-3:1:3)
    else
        xlim([0.55 1.45])
        ylim([-0.45 0.45])
        xticks(0.55:0.2:1.45)
        yticks(-0.45:0.2:0.45)
    end

end

lgd = legend(lg);
lgd.Layout.Tile = 'East';

%Save fig as .png
exportgraphics(gcf,append(folder,'\2Dshort_',plotname,'.png'),'Resolution',600)

% Repeat for long term

f = figure;
tiledlayout(2,2,"TileSpacing","tight");
f.Position = [2050 -300 1130 1000];

view(2)
hold on
grid on

tsecs = [3*30, 6*30, 12*30, 24*30].*(3600*24);
tdays = round(tsecs./(3600*24));
tmonths = round(tsecs./(3600*24*30));
tadim = round(tsecs./tcar,2);
tmin = cellfun(@min,texp_all);

for i = 1:length(tadim)

    subp = nexttile;
    subp.FontSize = 16;

    view(2)
    hold on
    grid on

    if tdays(i)<60
        title(sprintf('t = %s (%s %s)',string(tadim(i)),string(tdays(i)),'days'))
    else
        title(sprintf('t = %s (%s %s)',string(tadim(i)),string(tmonths(i)),'months'))
    end

    axis equal

    %dummy and SoI plots for legend
    lg(1) = plot(NaN,NaN,'b.','MarkerSize',24,'DisplayName','Orbiting debris');
    lg(2) = plot(NaN,NaN,'k.','MarkerSize',24,'DisplayName','Out of system');
    lg(3) = plot(NaN,NaN,'g.','MarkerSize',24,'DisplayName','Impact Earth');
    lg(4) = plot(NaN,NaN,'r.','MarkerSize',24,'DisplayName','Impact Moon');
    lg(5) = plot(NaN,NaN,'-c','LineWidth',2,'DisplayName','Initial orbits');
    lg(6) = plot(NaN,NaN,'-','Color',"#D95319",'LineWidth',2,'DisplayName','SoI Earth'); %soi earth
    lg(7) = plot(NaN,NaN,'-','Color',"#EDB120",'LineWidth',2,'DisplayName','SoI Moon'); %soi moon
    lg(8) = plot(NaN,NaN,'*','Color',"#7E2F8E",'MarkerSize',20,'DisplayName','Lagrange points'); % lagrange point

    xlabel('x (nondim)');
    ylabel('y (nondim)');
    circle(r_earth(1),r_earth(2),rsoie_2BP,"#D95319"); %soi earth
    DrawEarthCR3BPnondim(MU, re/lcar, re/lcar) %earth
    circle(r_moon(1),r_moon(2),rsoi_moon,"#EDB120"); %soi moon
    DrawMoonCR3BPnondim(MU,rm/lcar,rm/lcar) %moon
    plot(Lagrange_Points(:,1),Lagrange_Points(:,2),'.','MarkerSize',5,'Color',"#7E2F8E") % lagrange points
    cellfun(@(x) plot(x(:,1), x(:,2),'c','LineWidth',1), s0_all) % orbits

    idxcell = cellfun(@(x) abs(x-tadim(i))<0.001, texp_all, 'UniformOutput', false);

    for j=1:length(texp_all)
        if tmin(j)<=tadim(i)
            if ~any(idxcell{j})
                if out_of_system_all(j)
                    plot(sexp_all{j}(end,1), sexp_all{j}(end,2),'k.','MarkerSize',2)
                elseif impact_moon_all(j)
                    plot(sexp_all{j}(end,1), sexp_all{j}(end,2),'r.','MarkerSize',2)
                else
                    plot(sexp_all{j}(end,1), sexp_all{j}(end,2),'g.','MarkerSize',2)
                end
            else
                if orbit_debris_all(j)
                    plot(sexp_all{j}(idxcell{j},1), sexp_all{j}(idxcell{j},2),'b.','MarkerSize',3)
                elseif out_of_system_all(j)
                    plot(sexp_all{j}(idxcell{j},1), sexp_all{j}(idxcell{j},2),'k.','MarkerSize',3)
                elseif impact_moon_all(j)
                    plot(sexp_all{j}(idxcell{j},1), sexp_all{j}(idxcell{j},2),'r.','MarkerSize',3)
                else
                    plot(sexp_all{j}(idxcell{j},1), sexp_all{j}(idxcell{j},2),'g.','MarkerSize',3)
                end
            end
        end
    end

    xlim([-3 3])
    ylim([-3 3])
    xticks(-3:1:3)
    yticks(-3:1:3)

end

lgd = legend(lg);
lgd.Layout.Tile = 'East';

exportgraphics(gcf,append(folder,'\2Dlong_',plotname,'.png'),'Resolution',600)


end