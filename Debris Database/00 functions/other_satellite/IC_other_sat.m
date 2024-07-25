%%%% FUNCTION
%
% Plotting initial conditions of the break-up events and other satellite
%
%
%%%% OUTPUTS %%%%
% plot and png
%
%   Author: Marta Lopez Castro
%   Version: July 25, 2024
%
% *********************************************************************
% Copyright 2023 - 2025 David Canales Garcia; All Rights Reserved.
% *********************************************************************

function IC_other_sat(folder,plotname,ssat,ssat_unique,s0_fe,s0,tsat,tmin)


load('somedata.mat','lcar','MU','rsoi_moon','r_moon');
LP = lagrange;

color = turbo(8);

% Nondim
figure('Position',[2050 -300 1130 1000])
ax = gca;
ax.FontSize = 20;
hold on;
grid on;
axis equal;

xlabel('x (nondim)');
ylabel('y (nondim)');

xlim padded
ylim padded

for i=1:length(ssat)
    plot(ssat{i}(1,1),ssat{i}(1,2),'o','Color',color(i,:),'MarkerSize',6)
    text(ssat{i}(1,1),ssat{i}(1,2),sprintf(' %d',i),'Color',color(i,:),'FontSize',24,'HorizontalAlignment','left','FontWeight','bold')
end

plot(ssat_unique(:,1),ssat_unique(:,2),'c','LineWidth',1.5)
DrawMoonCR3BPnondim(MU, 1741/lcar, 1741/lcar) %moon
plot(LP(1:2,1),LP(1:2,2),'*','MarkerSize',8,'Color',"#7E2F8E") % lagrange points

lg(1) = plot(NaN,NaN,'-c','LineWidth',2,'DisplayName','Satellite orbit');
lg(2) = plot(NaN,NaN,'ok','MarkerSize',16,'DisplayName','Starting points');
lg(3) = plot(NaN,NaN,'-','Color',"#EDB120",'LineWidth',2,'DisplayName','SoI Moon'); %soi moon
lg(4) = plot(NaN,NaN,'*','Color',"#7E2F8E",'MarkerSize',20,'DisplayName','Lagrange points'); % lagrange point


legend(lg,'Location','eastoutside');

exportgraphics(gcf,append(folder,'\IC_other_',plotname,'.png'),'Resolution',600)

% Nondim
figure('Position',[2050 -300 1130 1000])
ax = gca;
ax.FontSize = 20;
hold on;
grid on;
axis equal;

xlabel('x (nondim)');
ylabel('y (nondim)');

xlim padded
ylim padded

for i=1:length(ssat)
    plot(ssat{i}(tsat{i}==tmin,1),ssat{i}(tsat{i}==tmin,2),'o','Color',color(i,:),'MarkerSize',6)
    text(ssat{i}(tsat{i}==tmin,1),ssat{i}(tsat{i}==tmin,2),sprintf(' %d',i),'Color',color(i,:),'FontSize',24,'HorizontalAlignment','left','FontWeight','bold')
end

plot(s0(:,1),s0(:,2),'--','LineWidth',2)
plot(s0_fe(1),s0_fe(2),'*r','MarkerSize',10,'LineWidth',1.5)
plot(ssat_unique(:,1),ssat_unique(:,2),'c','LineWidth',2)
DrawMoonCR3BPnondim(MU, 1741/lcar, 1741/lcar) %moon
plot(LP(1:2,1),LP(1:2,2),'*','MarkerSize',8,'Color',"#7E2F8E") % lagrange points


lg(1) = plot(NaN,NaN,'-c','LineWidth',2,'DisplayName','Satellite orbit');
lg(2) = plot(NaN,NaN,'ok','MarkerSize',16,'DisplayName','Starting points');
lg(3) = plot(NaN,NaN,'-','Color',"#EDB120",'LineWidth',2,'DisplayName','SoI Moon'); %soi moon
lg(4) = plot(NaN,NaN,'*','Color',"#7E2F8E",'MarkerSize',20,'DisplayName','Lagrange points'); % lagrange point
lg(5) = plot(NaN,NaN,'*r','MarkerSize',14,'LineWidth',1.2,'DisplayName','First explosion');


legend(lg,'Location','eastoutside');

exportgraphics(gcf,append(folder,'\IC_exp_other_',plotname,'.png'),'Resolution',600)

end