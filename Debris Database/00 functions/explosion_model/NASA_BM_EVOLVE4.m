%%%% FUNCTION
%
% Computing the NASA Standard Break-Up Model
%
%%%% INPUTS %%%%
% - m: mass of the spacecraft exploded   [kg]
% - lc: particle's characteristic length [m]
%
%%%% OUTPUTS %%%%
% - deltaV: ejection velocity of each fragment [m/s]
% - varargout: mass of each fragment           [kg]
%
%   Author: Marta Lopez Castro
%   Version: June 04, 2024
%
% *********************************************************************
% Copyright 2023 - 2025 David Canales Garcia; All Rights Reserved.
% *********************************************************************

function [deltaV,varargout] = NASA_BM_EVOLVE4(m,lc)

% Initializing number of fragments
N_lc = [];

while isempty(N_lc)

    % Initializing vector containing the lc of each fragment
    p_lc = [];

    % EVOLVE 4.0 explosions for spacecraft parts larger than 11 cm
    S = 1; %scaling factor
    % Number of fragments (lc>11cm)
    N_lc = 6*S.*lc.^-1.6;
    % lc of each fragment vector
    p_lc(1:ceil(N_lc)) = lc;


    % Mass correction from Krisko et. al., Boone et. al.
    p = rand(1,20);             % Maximum number of extra fragments
    lambda0 = log10(1);         % lambda min
    lambda1 = log10(5);         % lambda max
    lambda = -(1/1.6).*log10(10^(-1.6*lambda0)-p.*(10^(-1.6*lambda0)-10^(-1.6*lambda1))); % lambda
    extrap_lc = 10.^lambda;     % vector of the extra fragments' lc
    p_lc = horzcat(p_lc,extrap_lc);  % Concatenating with the rest of lc's

    % EVOLVE 4.0
    lambdac = log10(p_lc);
    % Area-to-mass ratio
    AM = 10.^(AM_dist(lambdac));
    % Cross-sectional area
    Ax = 0.556945.*p_lc.^2.0047077;
    % Ejection velocity
    deltaV = 10.^(deltaV_distr(log10(AM)));
    % Fragments mass
    fragM = Ax./AM;

    % Mass integrity from Krisko  
    N_lc = find(cumsum(fragM)>m*0.95,1); % Mass error margin
    deltaV = deltaV(1:N_lc);
    varargout{1} = fragM(1:N_lc);

    if varargout{1}>m
        N_lc = [];
    end

end

end

%%

function distr = AM_dist(lambdac)

% Area-to-mass distribution function
% Input: lambdac
% Output: AM distribution

% Initiliazing variables
alfa = zeros(size(lambdac));
mu1 = zeros(size(lambdac));
mu2 = zeros(size(lambdac));
sigma1 = zeros(size(lambdac));
sigma2 = zeros(size(lambdac));

% Cases depending on the value of lambda_c)
for i = 1:length(lambdac)
if lambdac(i)<=-1.95
    alfa(i) = 0;
elseif lambdac<0.55
    alfa(i) = 0.3+0.4*(lambdac(i)+1.2);
else
    alfa(i) = 1;
end

if lambdac(i)<=-1.1
    mu1(i) = -0.6;
elseif lambdac(i)<0
    mu1(i) = -0.6-0.318*(lambdac(i)+1.1);
else
    mu1(i) = -0.95;
end

if lambdac(i)<=-1.3
    sigma1(i) = 0.1;
elseif lambdac(i)<-0.3
    sigma1(i) = 0.1+0.2*(lambdac(i)+1.3);
else
    sigma1(i) = 0.3;
end

if lambdac(i)<=-0.7
    mu2(i) = -1.2;
elseif lambdac(i)<-0.1
    mu2(i) = -1.2-1.333*(lambdac(i)+0.7);
else
    mu2(i) = -2;
end

if lambdac(i)<=-0.5
    sigma2(i) = 0.5;
elseif lambdac(i)<-0.3
    sigma2(i) = 0.5-(lambdac(i)+0.5);
else
    sigma2(i) = 0.3;
end
end

% Area-to-mass distribution
distr = alfa.*normrnd(mu1,sigma1)+(1-alfa).*normrnd(mu2,sigma2);

end

function distr = deltaV_distr(chi)

% Ejection velocity distribution function
% Input: chi
% Output: deltaV distribution

% Mean and standard deviation
mu = 0.2.*chi+1.85;
sigma = 0.4;

% Ejection velocity distribution
distr = normrnd(mu,sigma);

end

