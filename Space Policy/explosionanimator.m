clc; clear; close all;
load('somedata.mat')
lstar = 384400; % [km] characteristic length

frameset = zeros(45000,3,1152);
orbitpick = 3;
i=1;
wb = waitbar(0,'Starting ...');
pause(0.1);
for sat = 1:1:200
    filename = append('C:\Users\blade\Documents\ERAU\ERAU RESEARCH\BOOM WORK\new matlab codes\01 orbits\specific_orbit_families\sp_orbit_4_8_DRO3\explosions\explosion_DRO3_sat_',num2str(sat),'_orbit_',num2str(orbitpick),'.mat');
    load(filename);
    for debris = 1:1:length(sexp)
        if length(sexp{debris}) < 1152
            len = length(sexp{debris});
            for row = (len+1):1:1152
                sexp{debris}(row,:) = sexp{debris}(len,:);
            end
        end
        for tstep = 1:1:1152
            frameset(i,1:3,tstep) = sexp{debris}(tstep,1:3) * lstar;
        end
        i = i+1;
    end
    waitbar(sat/200,wb, sprintf('Packing %d/200 sats', sat));
    stateset{sat} = sexp;
    timeset{sat} = texp;
end

frameset = frameset(1:i-1,1:3,:);

S(orbitpick).states = stateset;
S(orbitpick).times = timeset;
S(orbitpick).frames = frameset;

fprintf('Data Repacking Complete!\n')

%% Time Repacking
tspan = texp{1};
tspan = tspan*tstar;
tspan = tspan/3600/24;

%% Animation
close all;

figure(1)
axis manual
ax = gca;
ax.NextPlot = 'replaceChildren';
lim = 2.5*lstar;
xlim([-3*lstar 3*lstar])
ylim([-lim lim])
zlim([-lim lim])
ylabel('Y [km]','FontSize',12);
xlabel('X [km]','FontSize',12);
zlabel('Z [km]','FontSize',12);
frames = 1152;
XY(frames) = struct('cdata',[],'colormap',[]); % view(0, 90);
XZ(frames) = struct('cdata',[],'colormap',[]); % view(0, 0);
YZ(frames) = struct('cdata',[],'colormap',[]); % view(90, 0);
XYZ(frames) = struct('cdata',[],'colormap',[]); % view(3);



% figure(2)
wb = waitbar(0,'Starting ...');
pause(0.1);
% waitbar(0/frames,wb, sprintf('Animating 0/%d', frames));

for timestep = 1:1:1152
    figure(1)
    %This code is fulling the image file from a folder in the same directory
    %named "imagePlanets"
    
    npanels = 180;   % Number of globe panels around the equator deg/panel = 360/npanels
    alpha   = 1; % globe transparency level, 1 = opaque, through 0 = invisible
    
    %image_file = 'https://www.solarsystemscope.com/textures/download/2k_moon.jpg';
    
    image_file=imread(fullfile('00 funciones','results_analysis','plotting','imagePlanets','2k_earth.JPG'));
    erad = 3*6378;
    prad = 3*6378;
    [x, y, z] = ellipsoid(0-MU*lstar, 0, 0, erad, erad, prad, npanels);
    globe1 = surf(x, y, -z, 'FaceColor', 'none', 'EdgeColor', 0.5*[1 1 1]);
    %cdata = imread(image_file);
    set(globe1, 'FaceColor', 'texturemap', 'CData', image_file, 'FaceAlpha', alpha, 'EdgeColor', 'none');
    hold on

    image_file=imread(fullfile('00 funciones','results_analysis','plotting','imagePlanets','moonrev.png'));
%     image_file=imread(fullfile('00 funciones','results_analysis','plotting','imagePlanets','2k_earth.JPG'));
    erad = 8*1741;
    prad = 8*1741;
    [x, y, z] = ellipsoid((lstar-MU*lstar), 0, 0, erad, erad, prad, npanels);
    globe1 = surf(x, y, -z, 'FaceColor', 'none', 'EdgeColor', 0.5*[1 1 1]);
    %cdata = imread(image_file);
    set(globe1, 'FaceColor', 'texturemap', 'CData', image_file, 'FaceAlpha', alpha, 'EdgeColor', 'none');
    hold on

    LagrangeSize = 10;
    plot3(lstar-MU*lstar-60000, 0, 0, "r.", 'MarkerSize',LagrangeSize);
    plot3(lstar-MU*lstar+60000, 0, 0, "r.", 'MarkerSize',LagrangeSize);
    plot3(-1.00506265*lstar, 0, 0, "r.", 'MarkerSize',LagrangeSize);
    plot3((lstar-MU*lstar)/2, sqrt(3)*lstar/2, 0, "r.", 'MarkerSize',LagrangeSize);
    plot3((lstar-MU*lstar)/2, -sqrt(3)*lstar/2, 0, "r.", 'MarkerSize',LagrangeSize);

    ylabel('Y [km]','FontSize',12);
    xlabel('X [km]','FontSize',12);
    zlabel('Z [km]','FontSize',12);
    xlim([-3*lstar 3*lstar])
    ylim([-lim lim])
    zlim([-lim lim])
    plot3(frameset(:,1,timestep), frameset(:,2,timestep), frameset(:,3,timestep), "k.", 'MarkerSize',3);
    plot3(frameset(1:end-1,1,1), frameset(1:end-1,2,1), frameset(1:end-1,3,1)+lstar, "b", 'LineWidth',3);
    txt = ['Time = ' num2str(tspan(timestep)) ' days'];
    text(-2.7*lstar,-2.2*lstar,0,txt);
    waitbar(timestep/1152,wb, sprintf('Animating %d/1152 frames', timestep))
    
    figure(1)
    view(0,90)
    drawnow
    XY(timestep) = getframe(gcf);

%     view(0,0)
%     drawnow
%     XZ(timestep) = getframe(gcf);
% 
%     view(90,0)
%     drawnow
%     YZ(timestep) = getframe(gcf);
% 
%     view(-37.5, 20)
%     drawnow
%     XYZ(timestep) = getframe(gcf);

    hold off
end
    
v = VideoWriter("XY_3_BLUE.avi");
open(v)
writeVideo(v, XY)
close(v)
% 
% v = VideoWriter("XZ_49.avi");
% open(v)
% writeVideo(v, XZ)
% close(v)
% 
% v = VideoWriter("YZ_49.avi");
% open(v)
% writeVideo(v, YZ)
% close(v)
% 
% v = VideoWriter("XYZ_49.avi");
% open(v)
% writeVideo(v, XYZ)
% close(v)