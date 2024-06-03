function pc = poincare_points(s,dist,tol)

idx = and(abs(dist)<tol,vertcat(diff(dist),0)>0);
pc = s(idx,:);

end