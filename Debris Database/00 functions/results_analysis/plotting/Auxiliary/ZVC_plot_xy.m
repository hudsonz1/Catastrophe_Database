%%%% FUNCTION
%
% Plot 2D ZVC [nondim] in plane xy for selected JC
%
%%%% INPUTS %%%%
% - JC: selected Jacobi constant [nondim]
% - varargin: LineColor [RGB or Hex]
%
%%%% OUTPUTS %%%%
% plot ZVC in active figure
%
%   Author: Marta Lopez Castro
%   Version: July 25, 2024
%
% *********************************************************************
% Copyright 2023 - 2025 David Canales Garcia; All Rights Reserved.
% *********************************************************************
function ZVC_plot_xy(JC,varargin)

% Select color (chosen or default)
if ~isempty(varargin)
    color = varargin{1};
else 
    color = "#A2142F";
end

zf = 0;

% Load constants
load('somedata.mat','MU')

% Plot space grid
[x, y] = meshgrid(-1.5:0.005:1.5,-1.5:0.005:1.5);

% Jacobi constant equation (assuming z=0 and v=0)
f = @(xf,yf) 2*((1-MU)/sqrt((xf+MU)^2 + yf^2+ zf^2) + MU/sqrt((xf-1+MU)^2 + yf^2 + zf^2) + (xf^2 + yf^2)/2);

% Solve equation for each point of the grid
JCf = zeros(size(x));
for i = 1:size(x,1)
    for j = 1:size(x,2)
        JCf(i,j) = f(x(i,j),y(i,j));
    end
end

% Plot connecting points of equal JC
contour(x,y,JCf,[JC JC],'Color',color,'LineWidth',2)

end