%%%% FUNCTION
%
% Propagating CR3BP equations of motion
%
%%%% INPUTS %%%%
% - t: time of the integration [nondim]
% - s: state vector of position and velocity (x,y,z, vx,vy,vz) [nondim]
% - MU: mass ratio [nondim]
% - W: mean motion (W=1 in CR3BP) 
%
%%%% OUTPUTS %%%%
% - dsdt: state vector of the derivatives, velocity and acceleration
%         (vx,vy,vz, ax,ay,az) [nondim]
%
%   Author: Marta Lopez Castro
%   Version: June 04, 2024
%
% *********************************************************************
% Copyright 2023 - 2025 David Canales Garcia; All Rights Reserved.
% *********************************************************************

function dsdt = cr3bp(t, s, MU, W)

% Components of the state vector
x = s(1);
y = s(2);
z = s(3);
vx = s(4);
vy = s(5);
vz = s(6);

% Distance from larger primary (r1) and from smaller primary (r2)
r1 = sqrt((x+MU)^2 + y^2 + z^2);
r2 = sqrt((x-1+MU)^2 + y^2 + z^2);

% Accelerations according to the CR3BP equations of motion
ax = 2*W*vy + (W^2)*x - (1-MU)*(x+MU)/r1^3 - MU*(x-1+MU)/r2^3;
ay = -2*W*vx + (W^2)*y - y*(1-MU)/r1^3 - y*MU/r2^3;
az = -z*(1-MU)/r1^3 - z*MU/r2^3;

% Output
dsdt = [vx vy vz ax ay az]';

end