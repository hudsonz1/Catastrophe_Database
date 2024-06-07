%%%% FUNCTION
%
% Plot the Moon in the CR3BP system
%
%%%% INPUTS %%%%
% - MU: mass ratio [nondim]
% - erad: Ecuator Moon radius [nondim]
% - prad: Polar Moon radius [nondim]
%
%%%% OUTPUTS %%%%
% - Plot of the Moon nondim
%
%   Author: Marta Lopez Castro
%   Version: June 04, 2024
%
% *********************************************************************
% Copyright 2023 - 2025 David Canales Garcia; All Rights Reserved.
% *********************************************************************

function DrawMoonCR3BPnondim(MU, erad, prad)
lstar = 384400; % [km] characteristic length

%This code is fulling the image file from a folder in the same directory
%named "imagePlanets"

npanels = 180;   % Number of globe panels around the equator deg/panel = 360/npanels
alpha   = 1; % globe transparency level, 1 = opaque, through 0 = invisible

%
folder='imagePlanets';
image_file=imread(fullfile(folder,'moonrev.png'));

[x, y, z] = ellipsoid((1-MU), 0, 0, erad, erad, prad, npanels);
globe1 = surf(x, y, -z, 'FaceColor', 'none', 'EdgeColor', 0.5*[1 1 1]);
%cdata = imread(image_file);
set(globe1, 'FaceColor', 'texturemap', 'CData', image_file, 'FaceAlpha', alpha, 'EdgeColor', 'none');

end