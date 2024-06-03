clc
clear
close all

orbitinfo=struct2cell(load('Lyapunov_L1.mat')); % load in database
MU = orbitinfo{2,1}.massRatio;
lstar = 3.847479920112924e+05;


%Plot every increment orbit out of all database
Increments = 1;
[Integer, Remain] = quorem(sym(length(orbitinfo{4,1})), sym(Increments));
Integer = double(Integer);
Spacing = 1:Increments:Integer*Increments;

%Plot orbit up to a # orbit
% Start_Orbit = 1;
% End_Orbit = 96;
% Spacing = Start_Orbit:6:End_Orbit;

%Spacing = [5:18 20:40];
[All_States] = READ_DATA(orbitinfo, Spacing);


figure(1)
%DrawMoonCR3BP(MU, 1740/lstar, 1740/lstar)
DrawBoth(MU, 6378/lstar, 6378/lstar, 1740/lstar, 1740/lstar)
hold on
plot3(0.836915127902534,0, 0, 'k*') %L1
plot3(1.15568216540787, 0, 0, 'k*') %L2
plot3(-1.00506264580627, 0, 0, 'k*') %L3
plot3(0.487849414400000, 0.866025403784439, 0, 'k*') %L4
plot3(0.487849414400000, -0.866025403784439, 0, 'k*') %L5


for n = 1:length(All_States)
plot3(All_States{n}(:,1), All_States{n}(:,2), All_States{n}(:,3))
hold on
plot3(All_States{n}(1,1), All_States{n}(1,2), All_States{n}(1,3), '*')
set(gcf,'color','w')
grid on
axis equal
xlabel('X-Axis [NDU]')
ylabel('Y-Axis [NDU]')
zlabel('Z-Axis [NDU]')
pause

end
xlim([0.984 0.992])
ylim([-5e-3 5e-3])
zlim([-5e-3 5e-3])

% figure(2)
% DrawMoonCR3BP(MU, 1740/lstar, 1740/lstar)

function [All_States] = READ_DATA(orbitinfo, Spacing)
k = 1;
for i = Spacing
MU = orbitinfo{2,1}.massRatio;
n=1;
S=orbitinfo{4,1}; % state from database
T=orbitinfo{5,1}; % period from database
s0 = S{1,i}(1,:); % obtain state from database


%s0 = S{i,1}(1,:); % obtain state from database (Butterfly)

P = T{i,1}(end); % obtain period from database


options=odeset('RelTol',1e-12,'AbsTol',1e-12);
[Time, State] = ode45(@(t,x) CR3BP(t, x, MU, n), [0 P], s0, options);
All_States{k} = State(:,1:3);
k = k+1;
end 

end

function ds = CR3BP(t, s, MU, n)
    % Input:
    %   t - Epoch of the integration
    %   s - State (position and velocity only) at the previous epoch
    %   MU - Mass parameter of CR3BP system
    %   n - Mean-motion of the smaller primary around the larger primary,
    %        always 1.0 in any CR3BP
    % Output:
    %   ds - State derivatives (velocity and acc) at the input epoch t, 
    %           using equations-of-motion for CR3BP
    
    % Initialize state at input epoch t
    ds = zeros(6,1);
    
    % Retrieve components from current state
    x = s(1);
    y = s(2);
    z = s(3);
    vx = s(4);
    vy = s(5);
    vz = s(6);
    
    % Compute the distance from the smaller primary
    r = sqrt((x-1+MU)^2+y^2+z^2); % TODO: FILL IN THE EQUATION
    
    % Compute the distance from the larger primary
    d = sqrt((x+MU)^2+y^2+z^2); % TODO: FILL IN THE EQUATION
    
    % Assign velocities along x, y and z axes of the CR3BP rotating-frame
    ds(1) = vx; %x-dot
    ds(2) = vy; %y-dot
    ds(3) = vz; %z-dot
    
    % Assign accelerations along x, y and z axes of the CR3BP rotating-frame,
    % using equations of motion for CR3BP model
    ds(4) = (2*n*vy) + x - ((MU*(x-1+MU))/(r^3)) - (((1-MU)*(x+MU))/(d^3)); %x-dot-dot
    ds(5) = (-2*n*vx) + y - ((y*MU)/(r^3)) - ((y*(1-MU))/(d^3)); %y-dot-dot
    ds(6) = -((z*MU)/(r^3))-((z*(1-MU))/(d^3)); %z-dot-dot
    
    %In total ds = [x-dot y-dot z-dot x-dot-dot y-dot-dot z-dot-dot]
end

function DrawMoonCR3BP(MU, erad, prad)
%This code is fulling the image file from a folder in the same directory
%named "imagePlanets"

npanels = 180;   % Number of globe panels around the equator deg/panel = 360/npanels
alpha   = 1; % globe transparency level, 1 = opaque, through 0 = invisible

%image_file = 'https://www.solarsystemscope.com/textures/download/2k_moon.jpg';
folder='imagePlanets';  
image_file=imread(fullfile(folder,'moonrev.png'));

[x, y, z] = ellipsoid(1-MU, 0, 0, erad, erad, prad, npanels);
	globe1 = surf(x, y, -z, 'FaceColor', 'none', 'EdgeColor', 0.5*[1 1 1]);
	%cdata = imread(image_file);
	set(globe1, 'FaceColor', 'texturemap', 'CData', image_file, 'FaceAlpha', alpha, 'EdgeColor', 'none');
    
end

function DrawBoth(MU, erad_Earth, prad_Earth, erad_Moon, prad_Moon)
hold on
npanels = 180;   % Number of globe panels around the equator deg/panel = 360/npanels
alpha   = 1; % globe transparency level, 1 = opaque, through 0 = invisible

%image_file = 'https://www.solarsystemscope.com/textures/download/2k_moon.jpg';
folder='imagePlanets';  

image_file_Earth=imread(fullfile(folder,'2k_earth.jpg'));
image_file_Moon=imread(fullfile(folder,'moonrev.png'));


[x_Earth, y_Earth, z_Earth] = ellipsoid(-MU, 0, 0, erad_Earth, erad_Earth, prad_Earth, npanels);
globe_Earth = surf(x_Earth, y_Earth, -z_Earth, 'FaceColor', 'none', 'EdgeColor', 0.5*[1 1 1]);

[x_Moon, y_Moon, z_Moon] = ellipsoid(1-MU, 0, 0, erad_Moon, erad_Moon, prad_Moon, npanels);
globe_Moon = surf(x_Moon, y_Moon, -z_Moon, 'FaceColor', 'none', 'EdgeColor', 0.5*[1 1 1]);

set(globe_Earth, 'FaceColor', 'texturemap', 'CData', image_file_Earth, 'FaceAlpha', alpha, 'EdgeColor', 'none');
set(globe_Moon, 'FaceColor', 'texturemap', 'CData', image_file_Moon, 'FaceAlpha', alpha, 'EdgeColor', 'none');

end