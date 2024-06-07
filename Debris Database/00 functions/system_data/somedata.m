%%%% FUNCTION
%
% Creates a .mat file with useful constants
%
%%%% INPUTS %%%%
% - N/A
%
%%%% OUTPUTS %%%%
% - somedata.mat file
%
%   Author: Marta Lopez Castro
%   Version: June 04, 2024
%
% *********************************************************************
% Copyright 2023 - 2025 David Canales Garcia; All Rights Reserved.
% *********************************************************************

function somedata

% Some Data

r12 = 384400;                   % Earth-Moon distance (km)
re = 6378.137;                  % Earth radius (km)
rm = 1738;                      % Moon radius (km)
m1 = 5.9742e24;                 % Earth mass (kg)
m2  = 7.3483e22;                % Moon mass (kg)
MU = m2/(m1+m2);                % Mass ratio (nondim)

r_earth = [-MU 0 0]';           % Distance of Earth to Barycenter (nondim)
r_moon = [1-MU 0 0]';           % Distance of Moon to Barycenter (nondim)

G = 6.6742e-20;                 % Gravitational constant [km^3/(kg·s^2)]

mue = G*m1;                     % [km^3/s^2]
mum = G*m2;                     % [km^3/s^2]
W = sqrt(G*(m1+m2)/r12);        % Mean motion (W = 1)

lcar = r12;                     % Characteristic longitude (km)
mcar = m1 + m2;                 % Characteristic mass (kg)
tstar = sqrt(lcar^3/(G*mcar));  % Characteristic time (s)
tcar = 375190.25852;            % Characteristic time (s)
vcar = lcar/tcar;               % Characteristic velocity (km/s)
muecar = mue*(tcar^2)/lcar^3;   % (nondim)
mumcar = mum*tcar^2/lcar^3;     % (nondim)

re_star = re/lcar;              % Characteristic radius Earth (nondim)
rm_star = rm/lcar;              % Characteristic radius Moon (nondim)

rsoie_2BP = 924000/lcar;        % Sphere of Influence Earth (nondim)
rsoim_2BP = 66100/lcar;         % Sphere of Influence Moon 2BP (nondim)

rsoi_moon = 0.3902;             % Sphere of Influence Moon CR3BP (nondim)
rd = 10000;                     % Radius for the Danger Zone (km)
rh = 0.5;                       % Radius for the Hazard Zones (km)

rdanger = rd/lcar;              % (nondim)
rhazard = rh/lcar;              % (nondim)

Lagrange_Points = [0.836915036299579,0;                     % L1 (nondim)
                   1.155682235381702,0;                     % L2 (nondim)
                  -1.002025135583454,0;                     % L3 (nondim)
                   0.487849396206779,0.866025403784439;     % L4 (nondim)
                   0.487849396206779,-0.866025403784439];   % L5 (nondim)

save somedata.mat *;
 
end
