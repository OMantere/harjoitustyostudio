close all;

global correlations maxcount

for i=1:6
    surfplot(i, correlations, 'Keskimaarainen korrelaatio keskiarvon kanssa');
end
for i=1:6
    surfplot(i, maxcount./24, 'Osuus ajasta kun kokonaan taynna');
end
