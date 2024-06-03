figure
histogram(vpm)
ylabel('Number of Particles');
xlabel('Particle \Delta v (nondim)');

figure
view(3)
grid on
axis equal
title('Explosion velocity distribution')
xlabel('x speed (nondim)');
ylabel('y speed (nondim)');
zlabel('z speed (nondim)');
hold on
for i = 1:nel 
    plot3([0 vp(i,1)],[0 vp(i,2)], [0 vp(i,3)])   
end