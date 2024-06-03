clear all; clc; close all
%tic

%% Some data
somedata;
load('somedata.mat','*');

%% Explosion database
explosion_data = string(inputdlg('Enter .mat name:', 'Explosion Database'));
load(explosion_data,'*');

%% Times of study

% 6 months
t6 = 0.5*365*24*3600/tcar;
title6 = 'Final state of the explosion. T = 6 months';
for i = 1:length(sexp)
    [temp, idx_6] = min(abs(texp{i}-t6));
    sexp_6{i} = sexp{i}(1:idx_6,:);
    texp_6{i} = texp{i}(1:idx_6,:);
end
[orbit_debris_6, impact_moon_6, impact_earth_6, out_of_system_6] = classofdebris(texp_6,sexp_6,rsoie_2BP,rm_star,re_star,r_moon,r_earth);
[sexp_infm_6, sexp_infe_6, enter_m_6, enter_e_6] = enter_soi(lcar,nel,sexp_6);
threedplot(nel,s0exp,sexp_6,s,orbit_debris_6,impact_earth_6,impact_moon_6,title6)
twodplot(nel,s0exp,sexp_6,s,orbit_debris_6,impact_earth_6,impact_moon_6,title6)


%% Evolution of the fragments through the evolution time
% Vamos a hacer un plot que represente número de partículas que impactan la
% luna, que salen del sistema y que siguen orbitando
idx_out = cellfun(@length, out_of_system);
idx_earth = cellfun(@length, impact_earth);
idx_moon = cellfun(@length, impact_moon);
idx_max = max(cellfun(@length, texp));
for i = 1:idx_max
    accum_impactmoon(i) = sum(idx_moon<i);
    accum_impactearth(i) = sum(idx_earth<i);
    accum_out(i) = sum(idx_out<i);
    
end
accum_orbiting = nel - accum_impactmoon - accum_impactearth - accum_out;

figure
hold on
plot(texp{148}, accum_out,texp{148}, accum_impactmoon,texp{148}, accum_orbiting,texp{148}, accum_impactearth)
legend('out','moon','debris','earth')
out = accum_out';
moon = accum_impactmoon';
debris = accum_orbiting';
earth = accum_impactearth';
tbl = table(out, moon, debris, earth);
vars = {["out","moon","debris","earth"]};
figure
stackedplot(tbl,vars)

%% Sphere of Influence
tic
[sexp_infm, sexp_infe, enter_m, enter_e] = enter_soi(lcar,nel,sexp);

%% Explosion at L2, Satellite at L1

% For the final state of each particle
[dangerl1f, hazardl1f] = end_zones(nel,sexp,rhazard,rdanger);

% For each propagation time of the ODE45
[distancel1, distamod, dangerl1, hazardl1] = overtime_zones(nel, sexp, rhazard, rdanger);

%% Particles in Danger Zone over time

%pt = linspace(tspanexp(1),tspanexp(end),1000);
pt = linspace(min(tspanexp),max(tspanexp),1000);
danger_zone = zeros(size(pt,2),1);
avg_mass = zeros(size(pt,2),1);
avg_sp = zeros(size(pt,2),1);

for i = 1:nel
    for j = 1:length(pt)

        [temp,indx] = min(abs(texp{i}-pt(j)));

        %danger zone for sexp{i}(indx,:)
        if distamod{i}(indx,1) < rdanger

            danger_zone(j) = danger_zone(j) + 1;
            avg_mass(j) = avg_mass(j) + mp(i);
            avg_sp(j) = avg_sp(j) + norm(sexp{i}(indx,4:6));

        end
    end
end

average_speed = sum(avg_sp)/sum(danger_zone);

for i = 1:size(danger_zone,1)
    if danger_zone(i) ~= 0
        avg_mass(i) = avg_mass(i)./danger_zone(i);
        avg_sp(i) = avg_sp(i)./danger_zone(i);
    end
end

%% Danger Zone Plots

figure
subplot(3,1,1)
plot(pt,danger_zone)
title('Num in Danger Zone')
xlabel('time')
ylabel('Number of Particles')
xlim([tspanexp(1) tspanexp(end)])
%xlim([tspanexp(1) tspanexp(end)])

hold on
subplot(3,1,2)
plot(pt(avg_sp~=0),avg_sp(avg_sp~=0),'.b')
title('Avg Speed')
xlabel('time')
ylabel('average speed')
xlim([tspanexp(1) tspanexp(end)])
%xlim([tspanexp(1) tspanexp(end)])

subplot(3,1,3)
plot(pt(avg_mass~=0),avg_mass(avg_mass~=0),'.b')
title('Avg Mass')
xlabel('time')
ylabel('average mass')
xlim([tspanexp(1) tspanexp(end)])
%xlim([tspanexp(1) tspanexp(end)])

%% Plots
titlevarius = 'a';
twodplot(nel,s0exp,sexp,s,orbit_debris,impact_earth,impact_moon,titlevarius);

%% 3D plots
threedplot(nel,s0exp,sexp,s,orbit_debris,impact_earth,impact_moon,titlevarius);

%%
figure
view(2)
plot3(s(:, 1), s(:, 2), s(:,3),'b','LineWidth',2)
hold on
grid on
for i = 1:enter_m
    plot3(sexp_infm{i}(end,1),sexp_infm{i}(end,2),sexp_infm{i}(end,3), 'k.','MarkerSize',5)
end

xlim([-1.5 1.5])
ylim([-1.5 1.5])
zlim([-1.5 1.5])
xticks(-1.5:0.5:1.5)
yticks(-1.5:0.5:1.5)
zticks(-1.5:0.5:1.5)
xlabel('x (nondim)');
ylabel('y (nondim)');
zlabel('z (nondim)');
%plot3(xs,ys,zs,'*')
plot3(s0exp(1,1),s0exp(1,2),s0exp(1,3),'r.')
%sphere(r_earth,rsoie_2BP);
sphere_marta(r_moon,rsoi_moon);
% circle(r_earth(1),r_earth(2),rsoie_2BP);
% circle(r_moon(1),r_moon(2),rsoi_moon);

% Lagrange Points
for i = 1:5
    plot3(Lagrange_Points(i,1),Lagrange_Points(i,2),0,'*')
end


% % Earth
DrawEarthCR3BPnondim(MU, re/lcar, re/lcar)
%scatter3(r_earth(1),r_earth(2),r_earth(3));

% Moon
DrawMoonCR3BPnondim(MU,rm/lcar,rm/lcar)
%scatter3(r_moon(1),r_moon(2),r_moon(3));

%% SoI SubPlots
particles_in_SoI_moon(tspanexp,texp,sexp,nel);

%% Orbital parameters debris
% Something wrong with this function
muecar = 1-MU;
mumcar = MU;
orbitalpdeberis(r_earth, r_moon, muecar, mumcar, sexp_infe, sexp_infm)

toc