clear all
close all

% Saapuvien autojen jakauman ominaisuudet vuorokauden aikana
expected = [3 3 3 3 3 3 10 20 60 40 30 20 40 20 30 14 13 15 15 10 8 3 3 3];
variance = [3 3 3 2 2 2 3 5 7 10 10 10 7 5 3 2 2 3 3 4 4 2 2 2];

length = 24; % simulointiaika tunteina
cars = zeros(1,length); 
cars(1) = 10; % alustetaan autojen m‰‰r‰ ajan funktiona



norm = sum( (0.7*ones(1,5)).^(1:5) );
weights = 1/norm * (0.7*ones(1,5)).^(1:5); % poistuvien autojen painokertoimet

i = 1;
while (i<length)
   
   % saapuvien autojen m‰‰r‰ ajanhetkell‰ i:
   carsEntering = normrnd(expected(1 + rem(i,23)),variance(1 + rem(i,23)));
   
   % autot viimeiselt‰ viidelt‰ tunnilta
   lastCars = cars(max(i-4,1):i);
   
   % poistuvien autojen m‰‰r‰ (lastCars painotettu weightsill‰ + virhe)
   carsLeaving = sum(lastCars .* weights((end+1-size(lastCars,2)):end)) + normrnd(0,25);
   
   % autojen m‰‰r‰ seuraavalla ajanhetkell‰, rajoitettu v‰lille 0-200.
   cars(i+1) = min(max(cars(i) - carsLeaving,0)+carsEntering,200);
    
   i = i + 1;
    
    
    
end

plot(cars,'-o')