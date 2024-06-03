function particles_in_SoI_moon(tspanexp,texp,sexp,nel)

load('somedata.mat','*');
moon_rad = rm/lcar;
danger_moon = 0;
impact_moon = 0;

for i = 1:nel

    for j = 1:size(sexp{i},1)
        dista = sexp{i}(j,1:3) - r_moon;
        distamod{i}(j,1) = sqrt(dista(1)^2 + dista(2)^2 + dista(3)^2);
    end

    distance_moon(i) =  min(distamod{i});

    if  distance_moon(i) > moon_rad && distance_moon(i) < rsoi_moon
        danger_moon = danger_moon + 1;
    elseif distance_moon(i) <= moon_rad
        impact_moon = impact_moon + 1;
    end

end

pt = linspace(tspanexp(1),tspanexp(2),100);
inside_SoI = zeros(size(pt,2),1);
avg_mass = zeros(size(pt,2),1);
avg_sp = zeros(size(pt,2),1);

for i = 1:nel
    for j = 1:length(pt)

        [temp,indx] = min(abs(texp{i}-pt(j)));

        %danger zone for sexp{i}(indx,:)
        if distamod{i}(indx,1) < rsoi_moon

            inside_SoI(j) = inside_SoI(j) + 1;
            avg_mass(j) = avg_mass(j) + mp(i);
            avg_sp(j) = avg_sp(j) + norm(sexp{i}(indx,4:6));

        end
    end
end

average_speed = sum(avg_sp)/sum(inside_SoI);

for i = 1:size(inside_SoI,1)
    if inside_SoI(i) ~= 0
        avg_mass(i) = avg_mass(i)./inside_SoI(i);
        avg_sp(i) = avg_sp(i)./inside_SoI(i);
    end
end

% Danger Zone Plots

figure
subplot(3,1,1)
plot(pt,inside_SoI)
title('Num in SoI_{Moon}')
xlabel('time')
ylabel('Number of Particles')
xlim([tspanexp(1) tspanexp(end)])
%xlim([tspanexp(1) tspanexp(end)])

hold on
subplot(3,1,2)
plot(pt(avg_sp~=0),avg_sp(avg_sp~=0),'.b')
title('Avg Speed')
xlabel('time')
ylabel('average speed')
xlim([tspanexp(1) tspanexp(end)])
%xlim([tspanexp(1) tspanexp(end)])

subplot(3,1,3)
plot(pt(avg_mass~=0),avg_mass(avg_mass~=0),'.b')
title('Avg Mass')
xlabel('time')
ylabel('average mass')
xlim([tspanexp(1) tspanexp(end)])
%xlim([tspanexp(1) tspanexp(end)])

end