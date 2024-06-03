function orbitalpdeberis(r_earth, r_moon, muecar, mumcar, sexp_infe, sexp_infm)

    for i = 1:size(sexp_infe,2)
        rexp_e{i} = (sexp_infe{i}(end,1:3)-r_earth');
        rexpdot_e{i} = (sexp_infe{i}(end,4:6));
        orbit = state2orb_exp(rexp_e{i},rexpdot_e{i},muecar);
        a_e(i)   =    orbit.a;
        ecc_e(i) =    orbit.ecc;
        inc_e(i) =    orbit.inc;
        p_e(i)   =    orbit.p;
        pg_e(i)  =    a_e(i)*(1-ecc_e(i));
        ag_e(i)  =    a_e(i)*(1+ecc_e(i));
    end
    
    for i = 1:size(sexp_infe,2)
        if inc_e(i)>90 && inc_e(i)<200
            inc_e(i) = 180 - inc_e(i);
        end
    end
    
    for i = 1:size(sexp_infm,2)
        rexp_m{i} = (sexp_infm{i}(end,1:3)-r_moon');
        rexpdot_m{i} = (sexp_infm{i}(end,4:6));
        orbit = state2orb_exp(rexp_m{i},rexpdot_m{i},mumcar);
        a_m(i)   =    orbit.a;
        ecc_m(i) =    orbit.ecc;
        inc_m(i) =    orbit.inc;
        p_m(i)   =    orbit.p;
        pg_m(i)  =    a_m(i)*(1-ecc_m(i));
        ag_m(i)  =    a_m(i)*(1+ecc_m(i));
    end
    
    for i = 1:size(sexp_infm,2)
        if inc_m(i)>90 && inc_m(i)<200
            inc_m(i) = 180 - inc_m(i);
        end
    end
    % a = a(ecc<1);
    % ecc = ecc(ecc<1);
    % inc = inc(ecc<1);
    % p   = p(ecc<1);
    %%
    % orbital parameters orbiting earth
    figure
    sgtitle('Orbital elements')
    subplot(3,2,1)
    plot(p_e,'.b','MarkerSize',2)
    title('semilatutus rectum')
    xlabel('Number of particles')
    ylabel('p')
    subplot(3,2,2)
    plot(a_e,'.b','MarkerSize',2)
    title('semi-major axis')
    xlabel('Number of particles')
    ylabel('a')
    subplot(3,2,3)
    plot(ecc_e,'.b','MarkerSize',2)
    title('eccentricity')
    xlabel('Number of particles')
    ylabel('e')
    subplot(3,2,4)
    plot(inc_e,'.b','MarkerSize',2)
    title('inclination')
    xlabel('Number of particles')
    ylabel('i^{º}')
    subplot(3,2,5)
    plot(pg_e,'.b','MarkerSize',2)
    title('perigee')
    xlabel('Number of particles')
    ylabel('pg')
    subplot(3,2,6)
    plot(ag_e,'.b','MarkerSize',2)
    title('apogee')
    xlabel('Number of particles')
    ylabel('ag')
    
    % orbital parameters orbiting moon
    figure
    sgtitle('Orbital elements')
    subplot(3,2,1)
    plot(p_m,'.b','MarkerSize',2)
    title('semilatutus rectum')
    xlabel('Number of particles')
    ylabel('p')
    subplot(3,2,2)
    plot(a_m,'.b','MarkerSize',2)
    title('semi-major axis')
    xlabel('Number of particles')
    ylabel('a')
    subplot(3,2,3)
    plot(ecc_m,'.b','MarkerSize',2)
    title('eccentricity')
    xlabel('Number of particles')
    ylabel('e')
    subplot(3,2,4)
    plot(inc_m,'.b','MarkerSize',2)
    title('inclination')
    xlabel('Number of particles')
    ylabel('i^{º}')
    subplot(3,2,5)
    plot(pg_m,'.b','MarkerSize',2)
    title('perigee')
    xlabel('Number of particles')
    ylabel('pg')
    subplot(3,2,6)
    plot(ag_m,'.b','MarkerSize',2)
    title('apogee')
    xlabel('Number of particles')
    ylabel('ag')

end