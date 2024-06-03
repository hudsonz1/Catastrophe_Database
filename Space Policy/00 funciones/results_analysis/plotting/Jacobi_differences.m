%%
codepath = fileparts(matlab.desktop.editor.getActiveFilename); 
cd(append(codepath,'\01 orbits\specific_orbit_families\plots'));
histogram((JC_all-JC0_all))
xlim([-0.2 0.2])
ylabel('number of particles')
xlabel('\Delta Jacobi constant')
title('All debris')
saveas(gcf,'alldebrishist.png')

histogram(JC_all(logical(impact_earth_all))-JC0_all(logical(impact_earth_all)))
%xlim([-5 5])
ylabel('number of particles')
xlabel('\Delta Jacobi constant')
title('Impact earth')
saveas(gcf,'earthdebrishist.png')


histogram(JC_all(logical(impact_moon_all))-JC0_all(logical(impact_moon_all)))
xlim([-0.2 0.2])
ylabel('number of particles')
xlabel('\Delta Jacobi constant')
title('Impact moon')
saveas(gcf,'moondebrishist.png')

histogram(JC_all(logical(out_of_system_all))-JC0_all(logical(out_of_system_all)))
xlim([-0.2 0.2])
ylabel('number of particles')
xlabel('\Delta Jacobi constant')
title('Out of system')
saveas(gcf,'outdebrishist.png')

