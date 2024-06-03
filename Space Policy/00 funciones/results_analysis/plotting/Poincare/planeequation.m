function coeffs = planeequation(s)

d = -dot(s(1:3),s(4:6));
coeffs = [s(4), s(5), s(6), d];

end