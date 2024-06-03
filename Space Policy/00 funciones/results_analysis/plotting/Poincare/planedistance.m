function dist = planedistance(coeffs,x)

dist = (coeffs(1).*x(:,1)+coeffs(2).*x(:,2)+coeffs(3).*x(:,3)+coeffs(4))./norm(coeffs(1:3));

end