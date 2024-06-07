%%%% FUNCTION
%
% Propagation of the explosions
%
%%%% INPUTS %%%%
% - IC_exp: initial conditions for explosions
% - t0exp: initial time
% - evol_t: time of propagation
% - vp: delta of velocity for rach particle
% - varargin: progress bar parameters
%
%%%% OUTPUTS %%%%
% - s0exp: state vectors at explosion
% - texp: time vectors (after explosion)
% - sexp: state vectors (after explosion)
%
%   Author: Marta Lopez Castro
%   Version: June 04, 2024
%
% *********************************************************************
% Copyright 2023 - 2025 David Canales Garcia; All Rights Reserved.
% *********************************************************************

function [s0exp, texp, sexp] = explosion(IC_exp,t0exp,evol_t,vp,varargin)

% Load constants           
load('somedata.mat','*');

% Progress bar
if ~isempty(varargin)
    wb = varargin{1}{1};
    co = varargin{1}{2};
    no = varargin{1}{3};
end

% Number of particles
nel = length(vp);

% Initializating variables
s0exp = zeros(nel,6);

% CR3BP for each particle
for i = 1:nel

    %Updating progress bar
    if ~isempty(varargin)
        waitbar(((co-1)/no)+((i-1)/(no*nel)),wb,sprintf('Calculating explosions of orbit %d/%d\nParticle %d/%d',co,no,i,nel));
    end
    % CR3BP and ODE 45 inputs definition
    s0exp(i,:) = IC_exp;
    s0exp(i,4:6) = s0exp(i,4:6) + vp(i,:);
    tspanexp = t0exp:0.01:evol_t;
    tol = 1e-13;
    options = odeset('RelTol',tol,'AbsTol',tol,'Events',@(t, x) outofsystem_Event(t, x, rsoie_2BP,r_moon,r_earth,rm_star,re_star));
    % CR3BP propagation using ode 45
    [texp{i}, sexp{i}] = ode45(@(t, x) cr3bp(t, x, MU, 1), tspanexp, s0exp(i,1:6), options);

end

end


function [distance,isterminal,direction] = outofsystem_Event(t,x,rsoie_2BP,r_moon,r_earth,rm_star,re_star)
% ode events for type of debris
% Calculate position
position = vecnorm(x(1:3),2,1);
% Distance to moon
position_moon = vecnorm([x(1)-r_moon(1) x(2) x(3)],2,2);
%Distance to earth
position_earth = vecnorm([x(1)-r_earth(1) x(2) x(3)],2,2);
distance = all([position < rsoie_2BP, position_moon > rm_star, position_earth > re_star]); % The value that we want to be zero
isterminal = 1;  % Halt integration
direction = 0;   % The zero can be approached from either direction
end

