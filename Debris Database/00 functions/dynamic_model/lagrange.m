%%%% FUNCTION
%
% Computing the Lagrange points of the Earth-Moon CR3BP system
%
%%%% INPUTS %%%%
% - N/A
%
%%%% OUTPUTS %%%%
% - Lagrange_Points [x_L1 y_L1; x_L2 y_L2; x_L3 y_L3;
%                    x_L4 y_L4; x_L5 y_L5];             [nondim]
%
%   Author: Marta Lopez Castro
%   Version: June 04, 2024
%
% *********************************************************************
% Copyright 2023 - 2025 David Canales Garcia; All Rights Reserved.
% *********************************************************************

function Lagrange_Points = lagrange
clear all; clc
% Prev data
load somedata.mat *

% Set tolerance for convergence of solution
tol = 1e-10;

% Newton-Raphson
Gamma1 = Lagrange_Point_L1(0.15, MU, tol);
Gamma2 = Lagrange_Point_L2(0.16, MU, tol);
Gamma3 = Lagrange_Point_L3(0.95, MU, tol);

% Solutions to the Newton-Raphson methods
x_L1 = 1 - MU - Gamma1;
y_L1 = 0;
x_L2 = 1 - MU + Gamma2;
y_L2 = 0;
x_L3 = -MU - Gamma3;
y_L3 = 0;
% Triangular solutions
x_L4 = cosd(60) - MU;
y_L4 = sind(60);
x_L5 = cosd(60) - MU;
y_L5 = -sind(60);

% Lagrange Points
Lagrange_Points = [x_L1 y_L1;
    x_L2 y_L2;
    x_L3 y_L3;
    x_L4 y_L4;
    x_L5 y_L5];

end


%% Newton-Raphson functions to compute gamma1, gamma2, gamma3
%%%% INPUTS %%%%
% - Gamma_0: Initial guess
% - MU: Mass ratio
% - tol: tolerance
%
%%%% OUTPUTS %%%%
% - gamma: solution for distance from Moon to Lagrange point

function [Gamma1] = Lagrange_Point_L1(Gamma1_0, MU, tol)

% Initializing solution
Gamma1 = Gamma1_0;

% Function and derivative
f = 1 - MU - Gamma1 - (1-MU)/((1-Gamma1)^2) + MU/(Gamma1^2);
df = -1 - (1-MU)/((1-Gamma1)^3) - 2*MU/(Gamma1^3);

% Initializing iterations
n = 0;
diff = 1;

% Iterate: stop when 100 iterations are reached or when finding a solution
while n < 100 && abs(diff) > tol
    
    % Prev solution
    prevGamma1 = Gamma1;
    % Update solution
    Gamma1 = Gamma1 - (f/df);

    f = 1 - MU - Gamma1 - (1-MU)/((1-Gamma1)^2) + MU/(Gamma1^2);
    df = -1 - 2*(1-MU)/((1-Gamma1)^3) - 2*MU/(Gamma1^3);
    % Difference between prev solution and current solution
    diff = prevGamma1 - Gamma1;
    
    % Next iteration
    n = n + 1;

end
end

function [Gamma2] = Lagrange_Point_L2(Gamma2_0, MU, tol)

% Initializing solution
Gamma2 = Gamma2_0;

% Function and derivative
f = 1 - MU + Gamma2 - (1-MU)/((1+Gamma2)^2) - MU/(Gamma2^2);
df = 1 + (1-MU)/((1+Gamma2)^3) + 2*MU/(Gamma2^3);

% Initializing iterations
n = 0;
diff = 1;

% Iterate: stop when 100 iterations are reached or when finding a solution
while n < 100 && abs(diff) > tol

    % Prev solution
    prevGamma1 = Gamma2;
    % Update solution
    Gamma2 = Gamma2 - (f/df);

    f = 1 - MU + Gamma2 - (1-MU)/((1+Gamma2)^2) - MU/(Gamma2^2);
    df = 1 + (1-MU)/((1+Gamma2)^3) + 2*MU/(Gamma2^3);
    % Difference between prev solution and current solution
    diff = prevGamma1 - Gamma2;

    % Next iteration
    n = n + 1;

end
end

function [Gamma3] = Lagrange_Point_L3(Gamma3_0, MU, tol)

% Initializing solution
Gamma3 = Gamma3_0;

% Function and derivative
f = - MU - Gamma3 + (1-MU)/((-Gamma3)^2) + MU/(-1-Gamma3^2);
df = -1 + 2*(1-MU)/((-Gamma3)^3) + 2*MU/(-1-Gamma3^3);

% Initializing iterations
n = 0;
diff = 1;

% Iterate: stop when 100 iterations are reached or when finding a solution
while n < 100 && abs(diff) > tol

    % Prev solution
    prevGamma1 = Gamma3;
    % Update solution
    Gamma3 = Gamma3 - (f/df);

    f = - MU - Gamma3 + (1-MU)/((-Gamma3)^2) + MU/(-1-Gamma3^2);
    df = -1 + 2*(1-MU)/((-Gamma3)^3) + 2*MU/(-1-Gamma3^3);
    % Difference between prev solution and current solution
    diff = prevGamma1 - Gamma3;

    % Next iteration
    n = n + 1;

end
end

