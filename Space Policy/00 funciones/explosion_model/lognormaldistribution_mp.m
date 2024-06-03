function mp = lognormaldistribution_mp(msat,mmin)
    
    % Lognormal distribution
    mu = -1.7286;
    sigma = 1.4511;

    mptemp = [];

    while sum(mptemp) < msat
        mptemp(end+1) = lognrnd(mu,sigma);
        % while mptemp(end) < 0.2
        %     mptemp(end) = lognrnd(mu,sigma);
        % end
    end

    mp = mptemp(mptemp>mmin);

end