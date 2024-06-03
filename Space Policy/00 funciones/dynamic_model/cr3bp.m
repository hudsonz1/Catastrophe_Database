function dsdt = cr3bp(t, s, MU, W)

% dsdt = zeros(6,1);

x = s(1);
y = s(2);
z = s(3);
vx = s(4);
vy = s(5);
vz = s(6);

r1 = sqrt((x+MU)^2 + y^2 + z^2);
r2 = sqrt((x-1+MU)^2 + y^2 + z^2);

ax = 2*W*vy + (W^2)*x - (1-MU)*(x+MU)/r1^3 - MU*(x-1+MU)/r2^3;
ay = -2*W*vx + (W^2)*y - y*(1-MU)/r1^3 - y*MU/r2^3;
az = -z*(1-MU)/r1^3 - z*MU/r2^3;

dsdt = [vx vy vz ax ay az]';

end