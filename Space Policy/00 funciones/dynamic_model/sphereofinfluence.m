clear all; close all; clc;

%% Some data
somedata;
load('somedata.mat','*');

%% Earth surface
ge = G*m1/re^2;

% Earth influence
dist = 0.4878:0.0005:0.9878;
g_earth = (1-MU)./(dist.^2);

%% Moon surface
gm = G*m2/rm^2;

% Moon influence
g_moon = MU./((1-dist).^2);

ratio_soi = g_moon./g_earth;
[temp, idx] = min(abs(ratio_soi-0.03));
rsoi_moon = 1 - dist(idx);

%% Plots
figure
xline(1-rsoim_2BP)
hold on
plot(dist,g_earth,dist,g_moon,'LineWidth',2)
grid on
xlim([0.5 1])
legend('Earth','Moon')
title('gravitational acceleration')

figure
semilogy(dist,g_earth,dist,g_moon,'LineWidth',2)
hold on
xline(1-rsoim_2BP,'--')
xline(1-rsoi_moon)
legend('Earth','Moon','r_{SoI} 2BP','r_{SoI} CR3BP')
set(gca,'Ydir','reverse')
grid on
xlim([0.5 1])
xlabel('x [nondim]')
ylabel('Gravitational acceleration [nondim]')
title('Gravitational acceleration due to Earth and Moon along x-axis')



