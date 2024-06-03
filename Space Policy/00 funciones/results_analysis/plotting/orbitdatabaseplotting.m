function orbitdatabaseplotting

% get data
JC = evalin('caller','JC');
JC_sp = evalin('caller','JC_sp');
Store = evalin('caller','Store');
Store_sp = evalin('caller','Store_sp');


lstar = evalin('caller','lstar');
MU = evalin('caller','MU');

% Plotting Family

%Plotting
figure(1);
cmap=parula(length(JC));
hold on;
grid on;
axis equal;
hcb=colorbar;
set(gca,'colororder',cmap,'colormap',cmap)
title(hcb,'Jacobi Constant','FontSize',12)
set(gcf,'color','w')
caxis([min(JC) max(JC)]);

map = [flipud(cool)];

colormap(map)

for ii = 1:space:length(Store)-30
    Csurf = ones(length(Store{ii,1}(:,1)),1)*JC(ii);
    surf([Store{ii,1}(:,1) Store{ii,1}(:,1) Store{ii,1}(:,1)]*lstar, [Store{ii,1}(:,2) Store{ii,1}(:,2) Store{ii,1}(:,2)]*lstar,...
        [Store{ii,1}(:,3) Store{ii,1}(:,3) Store{ii,1}(:,3)]*lstar, [Csurf Csurf Csurf],'EdgeColor','interp','Linewidth',1);
end
DrawMoonCR3BP(MU, 1741, 1741)
plot(0.836915127902534*lstar,0, 'k*') %L1
plot(1.15568216540787*lstar, 0, 'k*') %L2
plot(-1.00506264580627*lstar, 0, 'k*') %L3
plot(0.487849414400000*lstar, 0.866025403784439*lstar, 'k*') %L4
plot(0.487849414400000*lstar, -0.866025403784439*lstar, 'k*') %L5
ylabel('Y [nondim]','FontSize',12);
xlabel('X [nondim]','FontSize',12);
zlabel('Z [nondim]','FontSize',12);
title('Orbit Family','FontSize',12)

% Plotting Specific Orbits

%Plotting
figure(2);
cmap=parula(length(JC_sp));
hold on;
grid on;
axis equal;
hcb=colorbar;
set(gca,'colororder',cmap,'colormap',cmap)
title(hcb,'Jacobi Constant','FontSize',12)
set(gcf,'color','w')
caxis([min(JC_sp) max(JC_sp)]);

map = [flipud(cool)];

colormap(map)

for ii = 1:length(Store_sp)
    Csurf = ones(length(Store_sp{ii,1}(:,1)),1)*JC_sp(ii);
    surf([Store_sp{ii,1}(:,1) Store_sp{ii,1}(:,1) Store_sp{ii,1}(:,1)]*lstar, [Store_sp{ii,1}(:,2) Store_sp{ii,1}(:,2) Store_sp{ii,1}(:,2)]*lstar,...
        [Store_sp{ii,1}(:,3) Store_sp{ii,1}(:,3) Store_sp{ii,1}(:,3)]*lstar, [Csurf Csurf Csurf],'EdgeColor','interp','Linewidth',1);
end
DrawMoonCR3BP(MU, 1741, 1741)
plot(0.836915127902534*lstar,0, 'k*') %L1
plot(1.15568216540787*lstar, 0, 'k*') %L2
plot(-1.00506264580627*lstar, 0, 'k*') %L3
plot(0.487849414400000*lstar, 0.866025403784439*lstar, 'k*') %L4
plot(0.487849414400000*lstar, -0.866025403784439*lstar, 'k*') %L5
ylabel('Y [nondim]','FontSize',12);
xlabel('X [nondim]','FontSize',12);
zlabel('Z [nondim]','FontSize',12);
title('Orbit Family','FontSize',12)

% Nondim
figure(3)
cmap=parula(length(JC_sp));
hold on;
grid on;
axis equal;
hcb=colorbar;
set(gca,'colororder',cmap,'colormap',cmap)
title(hcb,'Jacobi Constant','FontSize',12)
set(gcf,'color','w')
caxis([min(JC_sp) max(JC_sp)]);

map = [flipud(cool)];

colormap(map)
for ii = 1:length(Store_sp)
    Csurf = ones(length(Store_sp{ii,1}(:,1)),1)*JC_sp(ii);
    surf([Store_sp{ii,1}(:,1) Store_sp{ii,1}(:,1) Store_sp{ii,1}(:,1)], [Store_sp{ii,1}(:,2) Store_sp{ii,1}(:,2) Store_sp{ii,1}(:,2)],...
        [Store_sp{ii,1}(:,3) Store_sp{ii,1}(:,3) Store_sp{ii,1}(:,3)], [Csurf Csurf Csurf],'EdgeColor','interp','Linewidth',1);
end
DrawMoonCR3BPnondim(MU, 1741/lstar, 1741/lstar)
plot(0.836915127902534,0, 'k*') %L1
plot(1.15568216540787, 0, 'k*') %L2
plot(-1.00506264580627, 0, 'k*') %L3
plot(0.487849414400000, 0.866025403784439, 'k*') %L4
plot(0.487849414400000, -0.866025403784439, 'k*') %L5
rsoi_moon = 0.3902;
circle(1-MU,0,rsoi_moon);
ylabel('Y [nondim]','FontSize',12);
xlabel('X [nondim]','FontSize',12);
zlabel('Z [nondim]','FontSize',12);
title('Orbit Family','FontSize',12)
end