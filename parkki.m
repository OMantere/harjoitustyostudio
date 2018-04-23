clear all
close all

% Saapuvien autojen jakauman ominaisuudet vuorokauden aikana
defaultExpected = [3 3 3 3 3 3 10 20 60 40 30 20 40 20 30 14 13 15 15 10 8 3 3 3];
defaultSigma = [3 3 3 2 2 2 3 5 7 10 10 10 7 5 3 2 2 3 3 4 4 2 2 2];

length = 100; % simulointiaika vuorokausina
cars = zeros(1,length*24); 
leaving = zeros(1,length*24);
entering = zeros(1,length*24);
carcount = 10; % alustetaan autojen määrä ajan funktiona

fineFlags = (rand(1,length + 2)<= 1/30 ); % totuusarvovektori, joka määrää, saapuuko lappuliisa 
% fineFlags = zeros(1,length+2), jos ei lappuliisoja
norm = sum( (0.7*ones(1,5)).^(1:5) );
weights = 1/norm * (0.7*ones(1,5)).^(1:5); % poistuvien autojen painokertoimet

% iteroidaan vuorokausien yli:
i = 3;
while ((i-2)<=length)
    
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
       % autot viimeiseltä viideltä tunnilta
       lastCars = cars(max(currentIndex-4,1):currentIndex);
       
       % poistuvien autojen määrä (lastCars painotettu weightsillä +
       % virhe), rajoitettu välille 0..carcount.
       carsLeaving = sum(lastCars .* weights((end+1-size(lastCars,2)):end)) + normrnd(0,5);
       carsLeaving = min(max(0, carsLeaving),carcount);
       carcount = carcount - carsLeaving;
       
       % saapuvien autojen määrä, rajoitettu välille 0..(200-carcount)
       carsEntering = max(min(incomingCars(j), 200-carcount),0);
       carcount = carcount + carsEntering;
       
       leaving(currentIndex) = carsLeaving;
       entering(currentIndex) = carsEntering;
       cars(currentIndex) = carcount;
       
       j = j + 1;
       
   end
    
   i = i + 1
     
end

figure
hold on
plot(cars,'-b')
plot(leaving,'-r')
plot(entering,'-g')
