function [s0exp, texp, sexp] = explosion(IC_exp,t0exp,evol_t,vp,varargin)

% waitbar
if ~isempty(varargin)
    wb = varargin{1}{1};
    co = varargin{1}{2};
    no = varargin{1}{3};
end
nel = length(vp);

%  Create a different function to specify the position of the explosion           
    load('somedata.mat','*');
    s0exp = zeros(nel,6);
    

    %% CR3BP for each particle
    for i = 1:nel

        if ~isempty(varargin)
            waitbar(((co-1)/no)+((i-1)/(no*nel)),wb,sprintf('Calculating explosions of orbit %d/%d\nParticle %d/%d',co,no,i,nel));
        end
        s0exp(i,:) = IC_exp;
        s0exp(i,4:6) = s0exp(i,4:6) + vp(i,:);
        tspanexp = t0exp:0.01:(t0exp + evol_t);
        tol = 1e-13;
        options = odeset('RelTol',tol,'AbsTol',tol,'Events',@(t, x) outofsystem_Event(t, x, rsoie_2BP,r_moon,r_earth,rm_star,re_star));
        [texp{i}, sexp{i}] = ode45(@(t, x) cr3bp(t, x, MU, 1), tspanexp, s0exp(i,1:6), options);

    end

end


function [distance,isterminal,direction] = outofsystem_Event(t,x,rsoie_2BP,r_moon,r_earth,rm_star,re_star)
position = vecnorm(x(1:3),2,1);
position_moon = vecnorm([x(1)-r_moon(1) x(2) x(3)],2,2);
position_earth = vecnorm([x(1)-r_earth(1) x(2) x(3)],2,2);
distance = all([position < rsoie_2BP, position_moon > rm_star, position_earth > re_star]); % The value that we want to be zero
isterminal = 1;  % Halt integration 
direction = 0;   % The zero can be approached from either direction
end

