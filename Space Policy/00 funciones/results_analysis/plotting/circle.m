function circle(x,y,r)
    hold on
    theta = 0:pi/50:2*pi;
    xc = r * cos(theta) + x;
    yc = r * sin(theta) + y;
    plot(xc, yc);
end