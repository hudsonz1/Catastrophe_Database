function JC = jacobiconstant(MU, nel, s)

    for i = 1:nel
    
            x = s{i}(1,1);
            y = s{i}(1,2);
            z = s{i}(1,3);
            v = sqrt((s{i}(1,4))^2 + (s{i}(1,5))^2 + (s{i}(1,6))^2);
    
            rho_E = sqrt((x+MU)^2 + y^2 + z^2);
            rho_M = sqrt((x-1+MU)^2 + y^2 + z^2);
    
            U = (1-MU)/rho_E + MU/rho_M + (x^2 + y^2)/2;
    
            JC(i) = 2*U - v^2;

    end

end