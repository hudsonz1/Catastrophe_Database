%% ODE45 - State of the s/c
tspan = [0 Period(rownumber,1)];
tol = 1e-13;
options = odeset('RelTol',tol,'AbsTol',tol);
% CR3BP
[t, s] = ode45(@(t, x) cr3bp(t, x, MU, 1), tspan, s0(1:6), options);

%% Plot orbit and IP propagation
figure
view(3)

% Orbit Trajectory
plot3(s(:, 1), s(:, 2), s(:,3),'b','LineWidth',1)
axis equal
hold on
grid on

% % IP propagation
plot3(s0(1),s0(2),s0(3),'.r','MarkerSize',9)