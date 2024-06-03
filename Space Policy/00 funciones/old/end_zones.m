function [dangerl1f, hazardl1f] = end_zones(nel,sexp,rhazard,rdanger)
    
    Lagrange_Points = lagrange;
    
    % For the final state of each particle
    dangerl1f = 0;
    hazardl1f = 0;
    
    for i = 1:nel
        lagf{i} = [Lagrange_Points(1) 0 0];
        distaf{i}(1,1:3) = sexp{i}(end,1:3) - lagf{i};
        distamatf(i,1:3) = distaf{i}(1,:);
        distamodf{i} = sqrt((distamatf(i,1))^2 + (distamatf(i,2))^2 + (distamatf(i,3))^2);
        distancel1f(i) =  distamodf{i};
    
        if  distancel1f(i) > rhazard && distancel1f(i) < rdanger
            dangerl1f = dangerl1f + 1;
        elseif distancel1f(i) <= rhazard
            hazardl1f = hazardl1f + 1;
        end
    end

end