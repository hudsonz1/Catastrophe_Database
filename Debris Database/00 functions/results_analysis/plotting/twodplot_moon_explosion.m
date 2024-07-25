%%%% FUNCTION
%
% Plotting the debris snapshots for different time steps after explosions occur (zoom in moon SoI)
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
% - 2Dmoonexpshort_plotname.png
% - 2Dmoonexplong_plotname.png
%
%   Author: Marta Lopez Castro
%   Version: July 25, 2024
%
% *********************************************************************
% Copyright 2023 - 2025 David Canales Garcia; All Rights Reserved.
% *********************************************************************


function twodplot_moon_explosion(folder,plotname,texp_all,s0_all,sexp_all,orbit_debris_all,out_of_system_all,impact_moon_all,impact_earth_all)

somedata;
load('somedata.mat','*');
Lagrange_Points = lagrange;
Lagrange_Points = Lagrange_Points(1:2,:);

% Short term

% Generate and configure plot
f = figure;
tiledlayout(2,2,"TileSpacing","tight");
f.Position = [2050 -300 1130 1000];

view(2)
hold on
grid on

% Time frame
tadim = [0.5, 1, 1.5, 2];
tsecs = tadim.*tcar;
tdays = round(tsecs./(3600*24));
tmonths = round(tsecs./(3600*24*30));
tmin = cellfun(@min,texp_all);

% Subplots
for i = 1:length(tadim)

    subp = nexttile;
    subp.FontSize = 16;
    view(2)
    hold on
    grid on

    % Title in days or months
    if tdays(i)<60
        title(sprintf('t = %s (%s %s)',string(tadim(i)),string(tdays(i)),'days'))
    else
        title(sprintf('t = %s (%s %s)',string(tadim(i)),string(tmonths(i)),'months'))
    end

    % Configure plot
    axis equal

    xlabel('x (nondim)');
    ylabel('y (nondim)');

    % Plot system objects
    circle(r_moon(1),r_moon(2),rsoi_moon,"#EDB120"); %soi moon
    DrawMoonCR3BPnondim(MU,rm/lcar,rm/lcar) %moon
    plot(Lagrange_Points(:,1),Lagrange_Points(:,2),'*','MarkerSize',12,'Color',"#7E2F8E") % lagrange points
    cellfun(@(x) plot(x(:,1), x(:,2),'c','LineWidth',1), s0_all) % orbits
    if i == 1
        text(r_moon(1)+rsoi_moon/sqrt(2),r_moon(2)+rsoi_moon/sqrt(2),'\leftarrow SOI_{ Moon}') %soi moon
        text(r_moon(1),r_moon(2),' Moon')
    end

    % plot debris on different style according to its type
    idxcell = cellfun(@(x) abs(x-tadim(i))<0.001, texp_all, 'UniformOutput', false);

    for j=1:length(texp_all)
        if tmin(j)<=tadim(i)
            if vecnorm([sexp_all{j}(idxcell{j},1)-r_moon(1) sexp_all{j}(idxcell{j},2) sexp_all{j}(idxcell{j},3)],2,2) < rsoi_moon
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
    end

    xlim([0.55 1.45])
    ylim([-0.45 0.45])
    xticks(0.55:0.2:1.45)
    yticks(-0.45:0.2:0.45)

end

%dummy and SoI plots for legend
lg(1) = plot(NaN,NaN,'b.','MarkerSize',24,'DisplayName','Orbiting debris');
lg(2) = plot(NaN,NaN,'k.','MarkerSize',24,'DisplayName','Out of system');
lg(3) = plot(NaN,NaN,'g.','MarkerSize',24,'DisplayName','Impact Earth');
lg(4) = plot(NaN,NaN,'r.','MarkerSize',24,'DisplayName','Impact Moon');
lg(5) = plot(NaN,NaN,'-c','LineWidth',2,'DisplayName','Initial orbits');
lg(6) = plot(NaN,NaN,'-','Color',"#EDB120",'LineWidth',2,'DisplayName','SoI Moon'); %soi moon
lg(7) = plot(NaN,NaN,'*','Color',"#7E2F8E",'MarkerSize',20,'DisplayName','Lagrange points'); % lagrange point

lgd = legend(lg);
lgd.Layout.Tile = 'East';

%Save fig as .png
exportgraphics(gcf,append(folder,'\2Dmoonexpshort_',plotname,'.png'),'Resolution',600)

%Long term

f = figure;
tiledlayout(2,2,"TileSpacing","tight");
f.Position = [2050 -300 1130 1000];

view(2)
hold on
grid on

tadim = [2.5, 3, 3.5, 4];
tsecs = tadim.*tcar;
tdays = round(tsecs./(3600*24));
tmonths = round(tsecs./(3600*24*30));
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

    xlabel('x (nondim)');
    ylabel('y (nondim)');
    circle(r_moon(1),r_moon(2),rsoi_moon,"#EDB120"); %soi moon
    DrawMoonCR3BPnondim(MU,rm/lcar,rm/lcar) %moon
    plot(Lagrange_Points(:,1),Lagrange_Points(:,2),'*','MarkerSize',12,'Color',"#7E2F8E") % lagrange points
    cellfun(@(x) plot(x(:,1), x(:,2),'c','LineWidth',1), s0_all) % orbits

    idxcell = cellfun(@(x) abs(x-tadim(i))<0.001, texp_all, 'UniformOutput', false);

    for j=1:length(texp_all)
        if tmin(j)<=tadim(i)
            if vecnorm([sexp_all{j}(idxcell{j},1)-r_moon(1) sexp_all{j}(idxcell{j},2) sexp_all{j}(idxcell{j},3)],2,2) < rsoi_moon
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
    end

    xlim([0.55 1.45])
    ylim([-0.45 0.45])
    xticks(0.55:0.2:1.45)
    yticks(-0.45:0.2:0.45)

end

%dummy and SoI plots for legend
lg(1) = plot(NaN,NaN,'b.','MarkerSize',24,'DisplayName','Orbiting debris');
lg(2) = plot(NaN,NaN,'k.','MarkerSize',24,'DisplayName','Out of system');
lg(3) = plot(NaN,NaN,'g.','MarkerSize',24,'DisplayName','Impact Earth');
lg(4) = plot(NaN,NaN,'r.','MarkerSize',24,'DisplayName','Impact Moon');
lg(5) = plot(NaN,NaN,'-c','LineWidth',2,'DisplayName','Initial orbits');
lg(6) = plot(NaN,NaN,'-','Color',"#EDB120",'LineWidth',2,'DisplayName','SoI Moon'); %soi moon
lg(7) = plot(NaN,NaN,'*','Color',"#7E2F8E",'MarkerSize',20,'DisplayName','Lagrange points'); % lagrange point

lgd = legend(lg);
lgd.Layout.Tile = 'East';

exportgraphics(gcf,append(folder,'\2Dmoonexplong_',plotname,'.png'),'Resolution',600)

end