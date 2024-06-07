%%%% FUNCTION
%
% Determining the value of the Jacobi Constant
%
%%%% INPUTS %%%%
% - State: state vector (x, y, z, xdot, ydot, zdot) [nondim]
% - MU: mass ratio [nondim]
% - varargin: nel, number of particles
%
%%%% OUTPUTS %%%%
% - JC: Jacobi Constant [nondim]
%
%   Author: Marta Lopez Castro
%   Version: June 04, 2024
%
% *********************************************************************
% Copyright 2023 - 2025 David Canales Garcia; All Rights Reserved.
% *********************************************************************

function JC = JC_CR3BP(State, MU, varargin)

% Check number of input particles
    if ~isempty(varargin{1})
        sz = varargin{1};
        s = State;
    else 
        sz = 1;
        s{1} = State;
    end

for i =1:sz

    % Decomposition of state vector 
    x = s{i}(1);
    y = s{i}(2);
    z = s{i}(3);
    xdot = s{i}(4);
    ydot = s{i}(5);
    zdot = s{i}(6);

    % Distance from the smaller primary
    r = sqrt((x-1+MU)^2+y^2+z^2);
    
    % Distance from the larger primary
    d = sqrt((x+MU)^2+y^2+z^2);

    % Psuedo-potential
    U = (1-MU)/d + MU/r + .5*(x^2 + y^2);

    % Jacobi-Constant
    JC = 2*U -(xdot^2 + ydot^2 +zdot^2);

end