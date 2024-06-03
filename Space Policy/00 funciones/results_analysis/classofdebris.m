function [orbit_debris, impact_moon, impact_earth, out_of_system] = classofdebris(texp,sexp,rsoie_2BP,rm_star,re_star,r_moon,r_earth)

for i = 1:length(texp)
    position(i) = vecnorm(sexp{i}(end,1:3),2,2);
    position_moon(i) = vecnorm([sexp{i}(end,1)-r_moon(1) sexp{i}(end,2) sexp{i}(end,3)],2,2);
    position_earth(i) = vecnorm([sexp{i}(end,1)-r_earth(1) sexp{i}(end,2) sexp{i}(end,3)],2,2);
end

out_of_system = position >= rsoie_2BP;
impact_moon = position_moon <= rm_star;
impact_earth = position_earth <= re_star;
orbit_debris = ~any([position >= rsoie_2BP; position_moon <= rm_star; position_earth <= re_star]);
end