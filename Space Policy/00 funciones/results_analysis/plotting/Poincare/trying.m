
a = ICexp(4:6);
b = vertcat(a,null(a)');
for i=1:3

plot3([0 b(1,i)],[0 b(2,i)],[0 b(3,i)])
    hold on
end