figure
view(3)
grid on
axis equal
title('Explosion velocity distribution')
xlabel('x speed (nondim)');
ylabel('y speed (nondim)');
zlabel('z speed (nondim)');
hold on
plot3([0 3*(s0exp(1,4) - vp(1,1))],[0 3*(s0exp(1,5) - vp(1,2))], [0 3*(s0exp(1,6) - vp(1,3))],'--r','LineWidth',2)
for i = 1:nel
    plot3([0 s0exp(i,4)],[0 s0exp(i,5)], [0 s0exp(i,6)])   
end