function [out, correlation] = myfun(k, weight, errorsigma, lotsize, initialoccupancy, simulationlength, fines, doplot)

% Saapuvien autojen jakauman ominaisuudet vuorokauden aikana
defaultExpected = [3 3 3 3 3 3 10 20 60 40 30 20 40 20 30 14 13 15 15 10 8 3 3 3];
defaultSigma = [3 3 3 2 2 2 3 5 7 10 10 10 7 5 3 2 2 3 3 4 4 2 2 2];


carsAverage = zeros(1,24); % Keskimääräinen autojen lukumäärä kunakin tuntina
carsMin = lotsize * ones(1,24);
carsMax = zeros(1,24);


cars = zeros(1,simulationlength*24); 
leaving = zeros(1,simulationlength*24);
entering = zeros(1,simulationlength*24);
carcount = initialoccupancy; % alustetaan autojen määrä ajan funktiona

if fines
    fineFlags = (rand(1,simulationlength + 2)<= 1/30 ); % totuusarvovektori, joka määrää, saapuuko lappuliisa 
else
    fineFlags = zeros(1,simulationlength+2); %, jos ei lappuliisoja
end
fineFlags(1,1:2) = [0 0];
norm = sum( (weight*ones(1,k)).^(1:k) );
weights = 1/norm * (weight*ones(1,k)).^(1:k); % poistuvien autojen painokertoimet

% iteroidaan vuorokausien yli:
i = 3;
while ((i-2)<=simulationlength)
    
   % saapuvien autojen määrä joka tunti:
   if ( fineFlags(i-1) || fineFlags(i-2) ) % jos lappuliisa:
      incomingCars = normrnd( 3 * ones(1,24), 2 * ones(1,24) );
   else % muutoin defaulttiarvot:
      incomingCars = normrnd( defaultExpected, defaultSigma );
   end
   
   %iteroidaan vuorokauden tuntien yli:
   j = 1;
   while (j <= 24)
       currentIndex = 24 * (i-3) + j;
       % saapuvien autojen määrä, rajoitettu välille 0..(lotsize-carcount)
       carsEntering = max(min(incomingCars(j), lotsize-carcount),0);
       entering(currentIndex) = carsEntering;
       carcount = carcount + round(carsEntering); % Kokonaislukujen tarkkuudella

       % autot viimeiseltä k:lta tunnilta
       lastIncoming = entering(max(currentIndex-k+1,1):currentIndex);
       
       % poistuvien autojen määrä (lastIncoming painotettu weightsillä +
       % virhe), rajoitettu välille 0..carcount.
       carsLeaving = sum(lastIncoming .* weights((end+1-size(lastIncoming,2)):end)) + normrnd(0,errorsigma);
       carsLeaving = min(max(0, carsLeaving),carcount);
       leaving(currentIndex) = carsLeaving;
       carcount = carcount - round(carsLeaving); % Kokonaislukujen tarkkuudella
              
       cars(currentIndex) = carcount;
       carsAverage(j) = carsAverage(j) + carcount;

       
       if carcount <= carsMin(j)
          carsMin(j) = carcount;
       end
       
       if carcount >= carsMax(j)
           carsMax(j) = carcount;
       end
       
       j = j + 1;
       
   end
   
   i = i + 1;
     
end

carsAverage = carsAverage ./ simulationlength;
sum(cars) / size(cars,2);
t = 1:(simulationlength*24);

% Lasketaan keskimaarainen korrelaatio kaikkien kayrien yli keskimaarakayraan nahden
correlation = 0;
for i=1:simulationlength
    correlation = correlation + corr((cars((i-1)*24 + 1:i*24))', carsAverage');
end
if isnan(correlation)
    correlation = 0;
end
correlation = correlation / simulationlength;

if doplot
    figure
    hold on
    plot(t/24,cars,'-b')
    plot(t/24,leaving,'--r')
    plot(t/24,entering,'--g')
    xlabel('Aika (vuorokausia)')
    ylabel('Autoja')

    axis([-Inf Inf 0 160])

    for i=3:size(fineFlags,2) % Piirtää pystyviivan lappuliisan käyntiä seuraavalle keskiyölle 
       if (fineFlags(i))
          line([(i-2) (i-2)], [0 lotsize],'Color',[0.5 0.5 0.5],'LineStyle','--') 
       end
    end

    legend('parkkipaikalla','poistumassa','saapumassa')

    figure
    hold on

    plot(carsMax,'--')
    plot(carsAverage)
    plot(carsMin,'--')

    xlabel('Kellonaika (h)')
    ylabel('Autoja')
    legend('maksimi','keskiarvo','minimi')

end

out = [carsMax; carsAverage; carsMin];

end
