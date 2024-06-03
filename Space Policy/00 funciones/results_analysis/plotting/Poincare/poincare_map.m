close all

ICexp = IC_exp(1,:);

poicare_map(sexp,s0exp,ICexp)

function poicare_map(s,s0,IC)

tol = 1e-2;
coeffs = planeequation(IC);
dist = cellfun(@(x) planedistance(coeffs,x(:,1:3)),s,'UniformOutput',false);

pc = cellfun(@(x,y) poincare_points(x,y,tol),s,dist,'UniformOutput',false);


    fragmentevolution(s,10,2.13:0.01:2.22,pc)



end