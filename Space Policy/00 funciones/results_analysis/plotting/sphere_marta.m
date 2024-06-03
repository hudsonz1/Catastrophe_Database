function sphere(center, r)

% Sphere surface
[teta, phi] = meshgrid(linspace(0, 2*pi, 100), linspace(0, pi, 50));
x = r * sin(phi) .* cos(teta) + center(1);
y = r * sin(phi) .* sin(teta) + center(2);
z = r * cos(phi) + center(3);

% Sphere plot
hold on
surf(x, y, z,'EdgeColor','none','FaceColor','k','FaceAlpha',0.1);

end

