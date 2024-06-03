function deltaV = NASA_BM_EVOLVE4(m,lc)

N_lc = [];

while isempty(N_lc)
    p_lc = [];
    %EVOLVE 4.0 explosions for spacecraft parts larger than 11 cm
    S = 1; %scaling factor
    
    N_lc = 6*S.*lc.^-1.6;

    p_lc(1:ceil(N_lc)) = lc;


    %mass integrity from Krisko
    p = rand(1,20);
    lambda0 = log10(1);
    lambda1 = log10(5);
    lambda = -(1/1.6).*log10(10^(-1.6*lambda0)-p.*(10^(-1.6*lambda0)-10^(-1.6*lambda1)));
    extrap_lc = 10.^lambda;
    p_lc = horzcat(p_lc,extrap_lc);


    lambdac = log10(p_lc);
    AM = 10.^(AM_dist(lambdac));

    Ax = 0.556945.*p_lc.^2.0047077;

    deltaV = 10.^(deltaV_distr(log10(AM)));

    %mass integrity from Krisko

    fragM = Ax./AM;
    N_lc = find(cumsum(fragM)>m*0.95,1);

    deltaV = deltaV(1:N_lc);

end

end

%%


function distr = AM_dist(lambdac)

if lambdac<=-1.95
    alfa(1:length(lambdac)) = 0;
elseif lambdac<0.55
    alfa = 0.3+0.4*(lambdac+1.2);
else
    alfa(1:length(lambdac)) = 1;
end

if lambdac<=-1.1
    mu1(1:length(lambdac)) = -0.6;
elseif lambdac<0
    mu1 = -0.6-0.318*(lambdac+1.1);
else
    mu1(1:length(lambdac)) = -0.95;
end

if lambdac<=-1.3
    sigma1(1:length(lambdac)) = 0.1;
elseif lambdac<-0.3
    sigma1 = 0.1+0.2*(lambdac+1.3);
else
    sigma1(1:length(lambdac)) = 0.3;
end

if lambdac<=-0.7
    mu2(1:length(lambdac)) = -1.2;
elseif lambdac<-0.1
    mu2 = -1.2-1.333*(lambdac+0.7);
else
    mu2(1:length(lambdac)) = -2;
end

if lambdac<=-0.5
    sigma2(1:length(lambdac)) = 0.5;
elseif lambdac<-0.3
    sigma2 = 0.5-(lambdac+0.5);
else
    sigma2(1:length(lambdac)) = 0.3;
end

distr = alfa.*normrnd(mu1,sigma1)+(1-alfa).*normrnd(mu2,sigma2);

end

function distr = deltaV_distr(chi)

mu = 0.2.*chi+1.85;
sigma = 0.4;

distr = normrnd(mu,sigma);

end

