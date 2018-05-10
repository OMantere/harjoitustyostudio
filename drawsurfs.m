close all;

global correlations maxcount

for i=1:6
    surfplot(i, correlations, '');
end
for i=1:6
    surfplot(i, maxcount./24, '');
end
