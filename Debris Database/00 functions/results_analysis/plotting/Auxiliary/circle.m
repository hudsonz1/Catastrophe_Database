%%%% FUNCTION
%
% Plot a circle
%
%%%% INPUTS %%%%
% - x, y: position of the center
% - r: radius
% - varargin: color of the plot
%
%%%% OUTPUTS %%%%
% - Plot of the circle
% - varargout: line object
%
%   Author: Marta Lopez Castro
%   Version: June 04, 2024
%
% *********************************************************************
% Copyright 2023 - 2025 David Canales Garcia; All Rights Reserved.
% *********************************************************************

function varargout = circle(x,y,r,varargin)
    
    % Color
    if ~isempty(varargin)
        ccolor = varargin{1};
    else
        ccolor = 'b';
    end

    hold on
    % Circle
    theta = 0:pi/50:2*pi;
    xc = r * cos(theta) + x;
    yc = r * sin(theta) + y;

    % Saving properties of the plot
    varargout = {plot(xc, yc, 'Color', ccolor)};

end