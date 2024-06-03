function somedata

    % Some Data
  
    r12 = 384400;               % km
    re = 6378.137;              % Earth radius (km)
    rm = 1738;                  % Moon radius (km)
    m1 = 5.9742e24;             % Earth mass
    m2  = 7.3483e22;            % Moon mass
    MU = m2/(m1+m2);            % Mass ratio
    
    r_earth = [-MU 0 0]';      % Distance of Earth to Barycenter
    r_moon = [1-MU 0 0]';      % Distance of Moon to Barycenter
  
    G = 6.6742e-20;             % Gravitational constant [km^3/(kg·s^2)]
    
    mue = G*m1;                 % [km^3/s^2]
    mum = G*m2;
    W = sqrt(G*(m1+m2)/r12);    % Mean motion (W = 1)
    
    lcar = r12;                 % Characteristic longitude
    mcar = m1 + m2;             % Characteristic mass
    tstar = sqrt(lcar^3/(G*mcar));  % Characteristic time
    tcar = 375190.25852;        % Characteristic time
    vcar = lcar/tcar;           % Characteristic velocity
    muecar = mue*(tcar^2)/lcar^3;
    mumcar = mum*tcar^2/lcar^3;

    re_star = re/lcar;          % Characteristic radius Earth
    rm_star = rm/lcar;          % Characteristic radius Moon

    rsoie_2BP = 924000/lcar;    % Sphere of Influence Earth
    rsoim_2BP = 66100/lcar;     % Sphere of Influence Moon 2BP

    rsoi_moon = 0.3902;         % Sphere of Influence Moon CR3BP
    rd = 10000;                 % Radius for the Danger Zone
    rh = 0.5;                   % Radius for the Hazard Zones

    rdanger = rd/lcar;
    rhazard = rh/lcar;
    
    Lagrange_Points = [0.836915036299579,0;
                       1.155682235381702,0;
                      -1.002025135583454,0;
                       0.487849396206779,0.866025403784439;
                       0.487849396206779,-0.866025403784439];
    
    save somedata.mat *
 
end
