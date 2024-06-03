clc;
load('somedata.mat');
m1 = 5.9742e24;             % Earth mass
m2  = 7.3483e22;            % Moon mass
pi2 = m2/(m1+m2);           % Mass ratio
rad_danger = 10000 / 384400; 
parts_near_L2 = zeros(1,1152);
for timestep = 1:1:1152
    for particle = 1:1:length(frameset)
        part_loc = frameset(particle,:,timestep);
        dist_L2 = norm([part_loc(1) - (1-pi2 + 60000/384400), part_loc(2), part_loc(3)]);
        if dist_L2 <= rad_danger
            parts_near_L2(timestep) = parts_near_L2(timestep) + 1;
        end
    end
end

%% Plotting
timesteps = linspace(0,11.51, 1152);
plot(timesteps, parts_near_L2);
title('Particles Near L2');
xlabel('Time [NONDIM]')
ylabel('Particles')