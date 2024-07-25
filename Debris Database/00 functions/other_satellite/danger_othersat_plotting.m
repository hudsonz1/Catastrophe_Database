%%%% FUNCTION
%
% Plotting danger zones and expected hits with respect to a selected satellite
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

function  danger_othersat_plotting(folder,plotname,sexp_all,t0exp_all,tmax,ssat)

somedata;
load('somedata.mat','lcar','tcar');

tmin = min(t0exp_all);
timesteps = round(tmax*100+1);
nel = size(sexp_all,2);

L = lagrange;

danger = 10000/lcar;
hazard = 500/lcar;
EH_part = hazard^3/danger^3;

shortt = 50;

for i=1:length(ssat)
    isdangermat = zeros(timesteps,nel);

    for j = 1:nel
        vecstart = int64(t0exp_all(j)*100+1);
        idx = vecstart:vecstart+size(sexp_all{j},1)-1;
        partdanger = vecnorm(sexp_all{j}(:,1:3)-ssat{i}(idx,1:3),2,2)<danger;
        isdangermat(idx,j) = partdanger;
    end

accum_isdanger(i,:) = cumsum(sum(diff(vertcat(zeros(1,nel),isdangermat),1,2)==1,2))';
isdanger(i,:) = sum(isdangermat,2)';

end

EH_total = accum_isdanger(:,end).*EH_part;
writematrix([(1:1:length(ssat))',EH_total]',append(folder,'\EH_total_',plotname,'.xlsx'),'WriteMode','overwrite')
msg = msgbox(sprintf('%d: %0.2f\n',[(1:1:length(ssat))',EH_total]'),'Expected hits','modal'); 
while isvalid(msg)
    pause(0.01)
end

en = [];
answer = cell2mat(inputdlg('Select separate graph (number)'));
if  ~isempty(answer)
    en = eval(answer);
end
n_exc = setdiff(1:length(ssat),en);
exc = intersect(1:length(ssat),en);

time = (0:1:timesteps-1)*(tcar/100)/(3600*24);

color = turbo(8);

figure
f = tiledlayout('vertical');

xlabel(f,'time (days)','FontSize',24)
ylabel(f,'number of particles','FontSize',24)

for i=n_exc

    sp = nexttile;
    sp.FontSize = 18;

    hold on
    plot(time(time<=shortt),smooth(isdanger(i,time<=shortt)),'Color',color(i,:),'LineWidth',2)
    lgd = legend('');
    title(lgd,sprintf('%d',i),'FontSize',20)
    lgd.Box = 'off';
    if i~=n_exc(end)
        xticks([])
    end

end

f = gcf;
f.Position = [2500 -300 1280 960];
exportgraphics(f,append(folder,'\danger_',plotname,'.png'),'Resolution',600)

figure('Position',[2500 -300 1280 960])
ax = gca;
ax.FontSize = 20;
hold on
grid on

for i=n_exc
    plot(time(time<=shortt),accum_isdanger(i,time<=shortt).*EH_part,'Color',color(i,:),'LineWidth',1.5,'DisplayName',sprintf('%d',i))
end
legend('Location','eastoutside')
xlabel('time (days)','FontSize',24)
ylabel('number of expected hits','FontSize',24)

exportgraphics(gcf,append(folder,'\expected_hits_',plotname,'.png'),'Resolution',600)


if ~isempty(exc)
    figure
    f = tiledlayout('vertical');

    xlabel(f,'time (days)','FontSize',24)
    ylabel(f,'number of particles','FontSize',24)

    for i=exc

        sp = nexttile;
        sp.FontSize = 18;

        hold on
        plot(time(time<=shortt),smooth(isdanger(i,time<=shortt)),'Color',color(i,:),'LineWidth',2)
        lgd = legend('');
        title(lgd,sprintf('%d',i),"FontSize",20)
        lgd.Box = 'off';
        if i~=exc(end)
            xticks([])
        end

    end

    f = gcf;
    f.Position = [2500 -300 1280 960];
    exportgraphics(f,append(folder,'\danger_sep_',plotname,'.png'),'Resolution',600)

    figure('Position',[2500 -300 1280 960])
    ax = gca;
    ax.FontSize = 20;
    hold on
    grid on

    for i=exc
        plot(time(time<=shortt),accum_isdanger(i,time<=shortt).*EH_part,'Color',color(i,:),'LineWidth',1.5,'DisplayName',sprintf('%d',i))
    end
    legend('Location','eastoutside')
    xlabel('time (days)','FontSize',24)
    ylabel('number of expected hits','FontSize',24)

    exportgraphics(gcf,append(folder,'\expected_hits_sep_',plotname,'.png'),'Resolution',600)
end

end