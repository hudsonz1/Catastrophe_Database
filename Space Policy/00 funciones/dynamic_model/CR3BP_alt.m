function ds = CR3BP_alt(t, s, MU, n)
    % Input:
    %   t - Epoch of the integration
    %   s - State (position and velocity only) at the previous epoch
    %   MU - Mass parameter of CR3BP system
    %   n - Mean-motion of the smaller primary around the larger primary,
    %        always 1.0 in any CR3BP
    % Output:
    %   ds - State derivatives (velocity and acc) at the input epoch t, 
    %           using equations-of-motion for CR3BP
    
    % Initialize state at input epoch t
    ds = zeros(6,1);
    
    % Retrieve components from current state
    x = s(1);
    y = s(2);
    z = s(3);
    vx = s(4);
    vy = s(5);
    vz = s(6);
    
    % Compute the distance from the smaller primary
    r = sqrt((x-1+MU)^2+y^2+z^2); % TODO: FILL IN THE EQUATION
    
    % Compute the distance from the larger primary
    d = sqrt((x+MU)^2+y^2+z^2); % TODO: FILL IN THE EQUATION
    
    % Assign velocities along x, y and z axes of the CR3BP rotating-frame
    ds(1) = vx; %x-dot
    ds(2) = vy; %y-dot
    ds(3) = vz; %z-dot
    
    % Assign accelerations along x, y and z axes of the CR3BP rotating-frame,
    % using equations of motion for CR3BP model
    ds(4) = (2*n*vy) + x - ((MU*(x-1+MU))/(r^3)) - (((1-MU)*(x+MU))/(d^3)); %x-dot-dot
    ds(5) = (-2*n*vx) + y - ((y*MU)/(r^3)) - ((y*(1-MU))/(d^3)); %y-dot-dot
    ds(6) = -((z*MU)/(r^3))-((z*(1-MU))/(d^3)); %z-dot-dot
    
    %In total ds = [x-dot y-dot z-dot x-dot-dot y-dot-dot z-dot-dot]
end



