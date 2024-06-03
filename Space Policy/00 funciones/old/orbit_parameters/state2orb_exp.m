function orbit_exp = state2orb_exp(r, rdot, mu)

% Angular momentum vector
h = cross(r,rdot);  % [m2/s]

% Eccentricity
ecc = (cross(rdot,h)/mu) - (r/norm(r)); % []
ecc_m = norm(ecc);  % []

% Orbit inclination
inc = acos(h(3)/norm(h));   % [rad] 

% Semilatutus rectum
p = norm(h)^2/mu;

orbit_exp.p = p;
orbit_exp.a = p/(1-ecc_m^2);
orbit_exp.ecc = ecc_m;
orbit_exp.inc = rad2deg(inc);
orbit_exp.h = h;

end