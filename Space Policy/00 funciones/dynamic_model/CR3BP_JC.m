function JC = CR3BP_JC(State, MU)
    
    x = State(1);
    y = State(2);
    z = State(3);
    xdot = State(4);
    ydot = State(5);
    zdot = State(6);


    % Compute the distance from the smaller primary
    r = sqrt((x-1+MU)^2+y^2+z^2);
    
    % Compute the distance from the larger primary
    d = sqrt((x+MU)^2+y^2+z^2);

    % Psuedo-potential
    U = (1-MU)/d + MU/r + .5*(x^2 + y^2);

    % Jacobi-Constant
    JC = 2*U -(xdot^2 + ydot^2 +zdot^2);
end