function [sexp_infm, sexp_infe, enter_m, enter_e] = enter_soi(lcar,nel,sexp)

    load somedata.mat *

    ind_e = zeros(nel,1);
    ind_m = zeros(nel,1);
    
    de = zeros(nel,3);
    for i = 1:nel
    
        dm = sexp{i}(end,1:3)-r_moon(1:3)';
        mod_dm = sqrt(dm(1)^2 + dm(2)^2 + dm(3)^2);
    
        if mod_dm < rsoi_moon
            ind_m(i) = 1;
        else
            de = sexp{i}(end,1:3)-r_earth(1:3)';
            mod_de = sqrt(de(1)^2 + de(2)^2 + de(3)^2);
    
            if mod_de < rsoie_2BP
                ind_e(i) = 1;
            end
        end
    
    end
    
    sexp_infm = sexp(ind_m==1);
    sexp_infe = sexp(ind_e==1);
    enter_m = sum(ind_m);
    enter_e = sum(ind_e);

end