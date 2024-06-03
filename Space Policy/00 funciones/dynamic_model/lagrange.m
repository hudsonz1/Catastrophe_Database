% Lagrange Points


function Lagrange_Points = lagrange
clear all; clc
load somedata.mat *

tol = 1e-10;

Gamma1 = Lagrange_Point_L1(0.15, MU, tol);
Gamma2 = Lagrange_Point_L2(0.16, MU, tol);
Gamma3 = Lagrange_Point_L3(0.95, MU, tol);

x_L1 = 1 - MU - Gamma1;
y_L1 = 0;
x_L2 = 1 - MU + Gamma2;
y_L2 = 0;
x_L3 = -MU - Gamma3;
y_L3 = 0;
x_L4 = cosd(60) - MU;
y_L4 = sind(60);
x_L5 = cosd(60) - MU;
y_L5 = -sind(60);

Lagrange_Points = [x_L1 y_L1;
    x_L2 y_L2;
    x_L3 y_L3;
    x_L4 y_L4;
    x_L5 y_L5];

%% Plot

% orbit_me = 384400e3;
% pi1=m1/(m1+m2);
% x_earth=orbit_me;
% y_earth=orbit_me;
% xe = -MU;
% x_moon=2*orbit_me;
% y_moon=orbit_me;

% figure
% hold on; grid
% 
% xticks([])
% yticks([])
% 
% plot(xe, 0,'b.','MarkerSize',20)
% plot(1-MU, 0, 'k.', 'MarkerSize',15)
% 
% for i = 1:5
%     plot(Lagrange_Points(i,1),Lagrange_Points(i,2),'*', 'MarkerSize',7)
% end
% 
% legend({'Earth','Moon','L1','L2','L3','L4','L5'},'Location','northwest')
% 
end
%%
function [Gamma1] = Lagrange_Point_L1(Gamma1_0, MU, tol)
Gamma1 = Gamma1_0;

f = 1 - MU - Gamma1 - (1-MU)/((1-Gamma1)^2) + MU/(Gamma1^2);
df = -1 - (1-MU)/((1-Gamma1)^3) - 2*MU/(Gamma1^3);

n = 0;
diff = 1;

while n < 100 && abs(diff) > tol

    prevGamma1 = Gamma1;
    Gamma1 = Gamma1 - (f/df);

    f = 1 - MU - Gamma1 - (1-MU)/((1-Gamma1)^2) + MU/(Gamma1^2);
    df = -1 - 2*(1-MU)/((1-Gamma1)^3) - 2*MU/(Gamma1^3);
    diff = prevGamma1 - Gamma1;

    n = n + 1;
end
end

function [Gamma2] = Lagrange_Point_L2(Gamma2_0, MU, tol)
Gamma2 = Gamma2_0;

f = 1 - MU + Gamma2 - (1-MU)/((1+Gamma2)^2) - MU/(Gamma2^2);
df = 1 + (1-MU)/((1+Gamma2)^3) + 2*MU/(Gamma2^3);

n = 0;
diff = 1;

while n < 100 && abs(diff) > tol

    prevGamma1 = Gamma2;
    Gamma2 = Gamma2 - (f/df);

    f = 1 - MU + Gamma2 - (1-MU)/((1+Gamma2)^2) - MU/(Gamma2^2);
    df = 1 + (1-MU)/((1+Gamma2)^3) + 2*MU/(Gamma2^3);
    diff = prevGamma1 - Gamma2;

    n = n + 1;
end
end

function [Gamma3] = Lagrange_Point_L3(Gamma3_0, MU, tol)
Gamma3 = Gamma3_0;

f = - MU - Gamma3 + (1-MU)/((-Gamma3)^2) + MU/(-1-Gamma3^2);
df = -1 + 2*(1-MU)/((-Gamma3)^3) + 2*MU/(-1-Gamma3^3);

n = 0;
diff = 1;

while n < 100 && abs(diff) > tol

    prevGamma1 = Gamma3;
    Gamma3 = Gamma3 - (f/df);

    f = - MU - Gamma3 + (1-MU)/((-Gamma3)^2) + MU/(-1-Gamma3^2);
    df = -1 + 2*(1-MU)/((-Gamma3)^3) + 2*MU/(-1-Gamma3^3);
    diff = prevGamma1 - Gamma3;

    n = n + 1;
end
end