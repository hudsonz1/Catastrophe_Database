function Sn = twobody_eqn(ssat,mu)

% dominant term

rqi = ssat(1:3);
a = -mu*rqi/(norm(rqi)^3);

Sn = [ssat(4); ssat(5); ssat(6); a(1); a(2); a(3)];

end