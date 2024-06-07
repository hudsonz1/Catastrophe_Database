%%%% FUNCTION
%
% Clasify debris in types
%
%%%% INPUTS %%%%
% - texp: times of propagation [nondim]
% - sexp: state vectors        [nondim]
% - rsoie: radius SoI Earth    [nondim]
% - rm_star: radius of collision Moon  [nondim]
% - re_star: radius of collision Earth [nondim]
% - r_moon: radius of Moon [nondim]
% - r_earth: radius of Earth [nondim]
%
%%%% OUTPUTS %%%%
% Logical indexing vectors
% - orbit_debris
% - impact_moon
% - impact_earth
% - out_of_system
%
%   Author: Marta Lopez Castro
%   Version: June 04, 2024
%
% *********************************************************************
% Copyright 2023 - 2025 David Canales Garcia; All Rights Reserved.
% *********************************************************************

function [orbit_debris, impact_moon, impact_earth, out_of_system] = classofdebris(texp,sexp,rsoie,rm_star,re_star,r_moon,r_earth)

% Find last positions of each particle
for i = 1:length(texp)
    position(i) = vecnorm(sexp{i}(end,1:3),2,2);
    position_moon(i) = vecnorm([sexp{i}(end,1)-r_moon(1) sexp{i}(end,2) sexp{i}(end,3)],2,2);
    position_earth(i) = vecnorm([sexp{i}(end,1)-r_earth(1) sexp{i}(end,2) sexp{i}(end,3)],2,2);
end

% Check conditions
out_of_system = position >= rsoie; % Out of SoI of Earth
impact_moon = position_moon <= rm_star; % Impacted Moon
impact_earth = position_earth <= re_star; % Impacted Earth
orbit_debris = ~any([position >= rsoie; position_moon <= rm_star; position_earth <= re_star]); % Remaining particles
end