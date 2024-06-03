function distancel1 = distancel1(texp,sexp)

    times = 1:10:tfin;

    for i = 1:nel

        for j = 1:length(times)
        [min, ind] = min(abs(texp{i}-times(j)));
        distancel1(j) = sexp{i}(ind,1:6) - [Lagrange_Points(1) 0 0];
        end

    end


end
