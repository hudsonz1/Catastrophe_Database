clc; clear; close all;

%% Data Loading // Orbit Nodes
somedata;
load('somedata.mat','*');

SPO = load('Orbit Database Confidential\Short_Period_L4L5.mat');
DRO3 = load('Orbit Database Confidential\Distant_Retrograde_3D.mat');
HaloL1 = load('Orbit Database Confidential\Halo_L1.mat');
HaloL2 = load('Orbit Database Confidential\Halo_L2.mat');
Horseshoe = load('Orbit Database Confidential\Horseshoe.mat');
AxialL1 = load('Orbit Database Confidential\Axial_L1.mat');
AxialL2 = load('Orbit Database Confidential\Axial_L2.mat');

%% Node Propagation (DRO3)
% tol = 1e-13;
% options = odeset('RelTol',tol,'AbsTol',tol);
% 
% for i = 1:1:length(DRO3.nodes)
% %     tspan = linspace(0, DRO3.times{i}(end), 200);
%     tspan = [0 DRO3.times{i}(end)];
%     s0 = DRO3.nodes{i}(1,:);
%     [t{i}, s{i}] = ode45(@(t, x) cr3bp(t, x, pi2, 1), tspan, s0, options);
%     s_now = s{i};
%     t_now = t{i};
%     [L, ~] = size(s_now);
%     for j = 2:1:floor(L/2)
%        v_A = s_now(j-1,4:6);
%        v_B = s_now(j,4:6);
%        v_Angle = acos(dot(v_A, v_B) / norm(v_A) / norm(v_B));
%        t_diff = t_now(j) - t_now(j-1);
%        rate(j) = v_Angle / t_diff;
%        rate(1) = rate(2);
%        if rate(j) > rate(j-1)
%            ind1 = j;
%            t1 = t_now(ind1);
%        end
%     end
%     t2 = DRO3.times{i}(end) - t1;
%     tspan_01 = linspace(0, t1, 26);
%     tspan_1h = linspace(t1, DRO3.times{i}(end)/2, 76);
%     tspan_h2 = linspace(DRO3.times{i}(end)/2, t2, 76);
%     tspan_20 = linspace(t2, DRO3.times{i}(end), 26);
%     tdiff_01 = t1;
%     tdiff_1h = DRO3.times{i}(end)/2 - t1;
%     tdiff_h2 = t2 - DRO3.times{i}(end)/2;
%     tdiff_20 = DRO3.times{i}(end) - t2;
%     tspan_cos_01 = tdiff_01/2 * (1 - cos(pi/tdiff_01*(tspan_01-0)))+0;
%     tspan_cos_1h = tdiff_1h/2 * (1 - cos(pi/tdiff_1h*(tspan_1h-t1)))+t1;
%     tspan_cos_h2 = tdiff_h2/2 * (1 - cos(pi/tdiff_h2*(tspan_h2-DRO3.times{i}(end)/2)))+DRO3.times{i}(end)/2;
%     tspan_cos_20 = tdiff_20/2 * (1 - cos(pi/tdiff_20*(tspan_20-t2)))+t2;
%     s0 = DRO3.nodes{i}(1,:);
% %     tspan = [tspan_cos_01, tspan_cos_1h, tspan_cos_h2, tspan_cos_20];
%     tspan = [tspan_cos_01(1:25) tspan_cos_1h(1:75) tspan_cos_h2(1:75) tspan_cos_20(1:25)];
%     [t{i}, s{i}] = ode45(@(t, x) cr3bp(t, x, pi2, 1), tspan, s0, options);
% end
% 
% DRO3.initialnodes = s;

%% Node Propagation (SPO)
tol = 1e-13;
options = odeset('RelTol',tol,'AbsTol',tol);

for i = 1:1:length(SPO.nodes)
%     tspan = linspace(0, SPO.times{i}(end), 200);
    tspan = [0 SPO.times{i}(end)];
    s0 = SPO.nodes{i}(1,:);
    [t{i}, s{i}] = ode45(@(t, x) cr3bp(t, x, pi2, 1), tspan, s0, options);
    s_now = s{i};
    t_now = t{i};
    [L, ~] = size(s_now);
    for j = 2:1:floor(L/2)
       v_A = s_now(j-1,4:6);
       v_B = s_now(j,4:6);
       v_Angle = acos(dot(v_A, v_B) / norm(v_A) / norm(v_B));
       t_diff = t_now(j) - t_now(j-1);
       rate(j) = v_Angle / t_diff;
       rate(1) = rate(2);
       if rate(j) > rate(j-1)
           ind1 = j;
           t1 = t_now(ind1);
           s1 = s_now(ind1,1:6);
       end
    end
    tspan_01 = linspace(0, t1, 101);
    tspan_10 = linspace(t1, SPO.times{i}(end), 101);
    tdiff_01 = t1;
    tdiff_10 = SPO.times{i}(end) - t1;
    tspan_cos_01 = tdiff_01/2 * (1 - cos(pi/tdiff_01*(tspan_01-0)))+0;
    tspan_cos_10 = tdiff_10/2 * (1 - cos(pi/tdiff_10*(tspan_10-t1)))+t1;
    s0 = SPO.nodes{i}(1,:);
%     tspan = [tspan_cos_01, tspan_cos_1h, tspan_cos_h2, tspan_cos_20];
    tspan01 = [tspan_cos_01(1:100)];
    tspan10 = [tspan_cos_10(1:100)];
%     tspan = [0 t1];
    [t01{i}, s01{i}] = ode45(@(t, x) cr3bp(t, x, pi2, 1), tspan01, s0, options);
    [t10{i}, s10{i}] = ode45(@(t, x) cr3bp(t, x, pi2, 1), tspan10, s1, options);
    t{i} = [t01{i}; t10{i}];
    s{i} = [s01{i}; s10{i}];
end

SPO.initialnodes = s;

%% Node Propagation (Halo L1)
tol = 1e-13;
options = odeset('RelTol',tol,'AbsTol',tol);

for i = 1:1:length(HaloL1.nodes)
%     tspan = linspace(0, HaloL1.times{i}(end), 200);
    tspan = [0 HaloL1.times{i}(end)];
    s0 = HaloL1.nodes{i}(1,:);
    [t{i}, s{i}] = ode45(@(t, x) cr3bp(t, x, pi2, 1), tspan, s0, options);
    s_now = s{i};
    t_now = t{i};
    [L, ~] = size(s_now);
    for j = 2:1:floor(L/2)
       v_A = s_now(j-1,4:6);
       v_B = s_now(j,4:6);
       v_Angle = acos(dot(v_A, v_B) / norm(v_A) / norm(v_B));
       t_diff = t_now(j) - t_now(j-1);
       rate(j) = v_Angle / t_diff;
       rate(1) = rate(2);
       if rate(j) > rate(j-1)
           ind1 = j;
           t1 = t_now(ind1);
       end
    end
    tspan_01 = linspace(0, t1, 101);
    tspan_10 = linspace(t1, HaloL1.times{i}(end), 101);
    tdiff_01 = t1;
    tdiff_10 = HaloL1.times{i}(end) - t1;
    tspan_cos_01 = tdiff_01/2 * (1 - cos(pi/tdiff_01*(tspan_01-0)))+0;
    tspan_cos_10 = tdiff_10/2 * (1 - cos(pi/tdiff_10*(tspan_10-t1)))+t1;
    s0 = HaloL1.nodes{i}(1,:);
%     tspan = [tspan_cos_01, tspan_cos_1h, tspan_cos_h2, tspan_cos_20];
    tspan = [tspan_cos_01(1:100) tspan_cos_10(1:100)];
%     tspan = [0 t1];
    [t{i}, s{i}] = ode45(@(t, x) cr3bp(t, x, pi2, 1), tspan, s0, options);
end

HaloL1.initialnodes = s;

%% Node Propagation (Halo L2)
tol = 1e-13;
options = odeset('RelTol',tol,'AbsTol',tol);

for i = 1:1:length(HaloL2.nodes)
%     tspan = linspace(0, HaloL2.times{i}(end), 200);
    tspan = [0 HaloL2.times{i}(end)];
    s0 = HaloL2.nodes{i}(1,:);
    [t{i}, s{i}] = ode45(@(t, x) cr3bp(t, x, pi2, 1), tspan, s0, options);
    s_now = s{i};
    t_now = t{i};
    [L, ~] = size(s_now);
    for j = 2:1:floor(L/2)
       v_A = s_now(j-1,4:6);
       v_B = s_now(j,4:6);
       v_Angle = acos(dot(v_A, v_B) / norm(v_A) / norm(v_B));
       t_diff = t_now(j) - t_now(j-1);
       rate(j) = v_Angle / t_diff;
       rate(1) = rate(2);
       if rate(j) > rate(j-1)
           ind1 = j;
           t1 = t_now(ind1);
       end
    end
    tspan_01 = linspace(0, t1, 101);
    tspan_10 = linspace(t1, HaloL2.times{i}(end), 101);
    tdiff_01 = t1;
    tdiff_10 = HaloL2.times{i}(end) - t1;
    tspan_cos_01 = tdiff_01/2 * (1 - cos(pi/tdiff_01*(tspan_01-0)))+0;
    tspan_cos_10 = tdiff_10/2 * (1 - cos(pi/tdiff_10*(tspan_10-t1)))+t1;
    s0 = HaloL2.nodes{i}(1,:);
%     tspan = [tspan_cos_01, tspan_cos_1h, tspan_cos_h2, tspan_cos_20];
    tspan = [tspan_cos_01(1:100) tspan_cos_10(1:100)];
%     tspan = [0 t1];
    [t{i}, s{i}] = ode45(@(t, x) cr3bp(t, x, pi2, 1), tspan, s0, options);
end

HaloL2.initialnodes = s;

%% Node Propagation (Horseshoe)
tol = 1e-20;
options = odeset('RelTol',tol,'AbsTol',tol);

% for i = 1:1:length(Horseshoe.nodes)
for i = 10:1:10
%     tspan = linspace(0, Horseshoe.times{i}(end), 200);
    tspan = [0 Horseshoe.times{i}(end)];
    s0 = Horseshoe.nodes{i}(1,:);
    [t{i}, s{i}] = ode45(@(t, x) cr3bp(t, x, pi2, 1), tspan, s0, options);
    s_now = s{i};
    t_now = t{i};
%     [L, ~] = size(s_now);
%     for j = 2:1:floor(L/2)
%        v_A = s_now(j-1,4:6);
%        v_B = s_now(j,4:6);
%        v_Angle = acos(dot(v_A, v_B) / norm(v_A) / norm(v_B));
%        t_diff = t_now(j) - t_now(j-1);
%        rate(j) = v_Angle / t_diff;
%        rate(1) = rate(2);
%        if rate(j) > rate(j-1)
%            ind1 = j;
%            t1 = t_now(ind1);
%        end
%     end
    t1 = Horseshoe.times{i}(end)/2;
    tspan_01 = linspace(0, t1, 101);
    tspan_10 = linspace(t1, Horseshoe.times{i}(end), 101);
    tdiff_01 = t1;
    tdiff_10 = Horseshoe.times{i}(end) - t1;
    tspan_cos_01 = tdiff_01/2 * (1 - cos(pi/tdiff_01*(tspan_01-0)))+0;
    tspan_cos_10 = tdiff_10/2 * (1 - cos(pi/tdiff_10*(tspan_10-t1)))+t1;
    s0 = Horseshoe.nodes{i}(1,:);
%     tspan = [tspan_cos_01, tspan_cos_1h, tspan_cos_h2, tspan_cos_20];
%     tspan = [tspan_cos_01(1:100) tspan_cos_10(1:100)];
    tspan = [0 Horseshoe.times{i}(end)];
    [t{i}, s{i}] = ode45(@(t, x) cr3bp(t, x, pi2, 1), tspan, s0, options);
end

Horseshoe.initialnodes = s;
% DO NOT SAVE - DISCONTINUITY ISSUE

%% Node Propagation (Axial L1)
tol = 1e-13;
options = odeset('RelTol',tol,'AbsTol',tol);

for i = 1:1:length(AxialL1.nodes)
%     tspan = linspace(0, AxialL1.times{i}(end), 200);
    tspan = [0 AxialL1.times{i}(end)];
    s0 = AxialL1.nodes{i}(1,:);
    [t{i}, s{i}] = ode45(@(t, x) cr3bp(t, x, pi2, 1), tspan, s0, options);
    s_now = s{i};
    t_now = t{i};
    [L, ~] = size(s_now);
    for j = 2:1:floor(L/2)
       v_A = s_now(j-1,4:6);
       v_B = s_now(j,4:6);
       v_Angle = acos(dot(v_A, v_B) / norm(v_A) / norm(v_B));
       t_diff = t_now(j) - t_now(j-1);
       rate(j) = v_Angle / t_diff;
       rate(1) = rate(2);
       if rate(j) > rate(j-1)
           ind1 = j;
           t1 = t_now(ind1);
       end
    end
    tspan_01 = linspace(0, t1, 101);
    tspan_10 = linspace(t1, AxialL1.times{i}(end), 101);
    tdiff_01 = t1;
    tdiff_10 = AxialL1.times{i}(end) - t1;
    tspan_cos_01 = tdiff_01/2 * (1 - cos(pi/tdiff_01*(tspan_01-0)))+0;
    tspan_cos_10 = tdiff_10/2 * (1 - cos(pi/tdiff_10*(tspan_10-t1)))+t1;
    s0 = AxialL1.nodes{i}(1,:);
%     tspan = [tspan_cos_01, tspan_cos_1h, tspan_cos_h2, tspan_cos_20];
    tspan = [tspan_cos_01(1:100) tspan_cos_10(1:100)];
%     tspan = [0 t1];
    [t{i}, s{i}] = ode45(@(t, x) cr3bp(t, x, pi2, 1), tspan, s0, options);
end

AxialL1.initialnodes = s;

%% Node Propagation (Axial L2)
tol = 1e-13;
options = odeset('RelTol',tol,'AbsTol',tol);

for i = 1:1:length(AxialL2.nodes)
%     tspan = linspace(0, AxialL2.times{i}(end), 200);
    tspan = [0 AxialL2.times{i}(end)];
    s0 = AxialL2.nodes{i}(1,:);
    [t{i}, s{i}] = ode45(@(t, x) cr3bp(t, x, pi2, 1), tspan, s0, options);
    s_now = s{i};
    t_now = t{i};
    [L, ~] = size(s_now);
    for j = 2:1:floor(L/2)
       v_A = s_now(j-1,4:6);
       v_B = s_now(j,4:6);
       v_Angle = acos(dot(v_A, v_B) / norm(v_A) / norm(v_B));
       t_diff = t_now(j) - t_now(j-1);
       rate(j) = v_Angle / t_diff;
       rate(1) = rate(2);
       if rate(j) > rate(j-1)
           ind1 = j;
           t1 = t_now(ind1);
       end
    end
    tspan_01 = linspace(0, t1, 101);
    tspan_10 = linspace(t1, AxialL2.times{i}(end), 101);
    tdiff_01 = t1;
    tdiff_10 = AxialL2.times{i}(end) - t1;
    tspan_cos_01 = tdiff_01/2 * (1 - cos(pi/tdiff_01*(tspan_01-0)))+0;
    tspan_cos_10 = tdiff_10/2 * (1 - cos(pi/tdiff_10*(tspan_10-t1)))+t1;
    s0 = AxialL2.nodes{i}(1,:);
%     tspan = [tspan_cos_01, tspan_cos_1h, tspan_cos_h2, tspan_cos_20];
    tspan = [tspan_cos_01(1:100) tspan_cos_10(1:100)];
%     tspan = [0 t1];
    [t{i}, s{i}] = ode45(@(t, x) cr3bp(t, x, pi2, 1), tspan, s0, options);
end

AxialL2.initialnodes = s;

%% Output Data Plotting
for i = 10:1:10
    hold on
    s_now = s{i};
    plot3(s_now(:,1), s_now(:,2), s_now(:,3),'k*')
%     plot3(s_now(ind,1), s_now(ind,2), s_now(ind,3), 'k*', 'MarkerSize', 10)
end
title('AxialL1 Initial Satellite Layout')
xlabel('X [NONDIM]')
ylabel('Y [NONDIM]')
zlabel('Z [NONDIM]')