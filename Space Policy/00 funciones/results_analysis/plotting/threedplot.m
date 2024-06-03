function threedplot(nel,s0exp,sexp,s,orbit_debris,impact_earth,impact_moon,specific_title)
    somedata;
    load('somedata.mat','*');
    Lagrange_Points = lagrange;

    figure
    view(3)

    % Orbit Trajectory
    plot3(s(:, 1), s(:, 2), s(:,3),'b','LineWidth',1)

    hold on
    grid on
    % Explosion
    for i = 1:length(orbit_debris)
        plot3(orbit_debris{i}(end,1), orbit_debris{i}(end,2), orbit_debris{i}(end,3),'k.','MarkerSize',2)
    %plot3(sexp{i}(end,1), sexp{i}(end,2), sexp{i}(end,3),'k.','MarkerSize',2)
    end

    % Impacts
    for i = 1:length(impact_moon)
        plot3(impact_moon{i}(end,1), impact_moon{i}(end,2), impact_moon{i}(end,3),'r.','MarkerSize',2)
    end

    for i = 1:length(impact_earth)
        plot3(impact_earth{i}(end,1), impact_earth{i}(end,2), impact_earth{i}(end,3),'r.','MarkerSize',2)
    end

    % title('CR3BP')
    %axis equal
    xlim([-3 3])
    ylim([-3 3])
    zlim([-3 3])
    xticks(-3:1:3)
    yticks(-3:1:3)
    zticks(-3:1:3)
    xlabel('x (nondim)');
    ylabel('y (nondim)');
    zlabel('z (nondim)');
    %plot3(xs,ys,zs,'*')
    plot3(s0exp(1,1),s0exp(1,2),s0exp(1,3),'r.')
    %sphere(r_earth,rsoie);
    sphere_marta(r_moon,rsoi_moon);
    % circle(r_earth(1),r_earth(2),rsoie);
    % circle(r_moon(1),r_moon(2),rsoi_moon);
    
    % Lagrange Points
    for i = 1:5
        plot3(Lagrange_Points(i,1),Lagrange_Points(i,2),0,'*')
    end
    
    % % Earth
    DrawEarthCR3BPnondim(MU, re/lcar, re/lcar)
    %scatter3(r_earth(1),r_earth(2),r_earth(3));
    
    % Moon
    DrawMoonCR3BPnondim(MU,rm/lcar,rm/lcar)
    %scatter3(r_moon(1),r_moon(2),r_moon(3));
    title(specific_title)
end




