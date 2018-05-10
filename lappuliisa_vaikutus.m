close all

fineprobs = 0:0.02:1;

averages = zeros(size(fineprobs))

for i = 1:length(fineprobs)
   [out, corr] = parkki(5, 0.7, 5, 200, 10, 2500, fineprobs(i), 0);
    hourlyaverage = sum(out(2,:))/24;
    averages(i) = hourlyaverage;
    i
end

figure
plot(30 * fineprobs, averages)
xlabel('Lappuliisoja 30 päivässä keskimäärin')
ylabel('Autoja keskimäärin tunnissa')