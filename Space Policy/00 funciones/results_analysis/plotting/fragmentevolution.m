function fragmentevolution(sexp,nel,JC,pc)
    %
    format short
    m1 = 5.9742e24;         
    m2  = 7.3483e22;        
    MU = m2/(m1+m2);       
    r_earth = [-MU 0 0]';  
    r_moon = [1-MU 0 0]';
    Lagrange_Points = [0.8369 0;
                       1.1557 0;
                      -1.0020 0;
                       0.4878 0.8660;
                       0.4878 -0.8660];
    
    for i = 1:nel
        cf = figure('visible','off');
        plot3(sexp{i}(:,1), sexp{i}(:,2),sexp{i}(:,3))
    
        hold on
        grid on
    
        title(append('Particle ',num2str(i),'. C = ',num2str(JC(i))))
        axis equal
        xlim([-3 3])
        ylim([-3 3])
        zlim([-3 3])
        xticks(-3:1:3)
        yticks(-3:1:3)
        zticks(-3:1:3)
        
        xlabel('x (nondim)');
        ylabel('y (nondim)');
        zlabel('z (nondim)');
        
        % circleroie = circle(r_earth(1),r_earth(2),rsoie);
        % circleroim = circle(r_moon(1),r_moon(2),rsoim);
    
    
        % Lagrange Points
        for j = 1:5
            plot3(Lagrange_Points(j,1),Lagrange_Points(j,2),0,'*')
        end

        % % Earth
        scatter3(r_earth(1),r_earth(2),r_earth(3));

        % Moon
        scatter3(r_moon(1),r_moon(2),r_moon(3));


        plot3(pc{i}(:,1),pc{i}(:,2),pc{i}(:,3),'.r','MarkerSize',8)

        if JC(i) < 1
            saveas(cf,strcat('1particle_',num2str(i),'_',num2str(JC(i)),'.jpg'))
        else
            saveas(cf,strcat('particle_',num2str(i),'_',num2str(JC(i)),'.jpg'))
        end

        close(cf)

    end

end