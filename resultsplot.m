function [] = resultsplot(l, m, n, o)
global len1 len2 len3 len4 k_s errorsigma_s lotsize_s weight_s results correlations
figure
hold on
k = k_s(l);
errorsigma = errorsigma_s(m);
lotsize = lotsize_s(n);
weight = weight_s(o);
title(['k = ' num2str(k) ', errorsigma = ' num2str(errorsigma) ', lotsize = ' num2str(lotsize), ', weight = ' num2str(weight)])
v = results(l, m, n, o, :, :);
c = correlations(l, m, n, o, :, :)
carsMax = squeeze(v(1, 1, 1, 1, 1, :));
carsAverage = squeeze(v(1, 1, 1, 1, 2, :));
carsMin = squeeze(v(1, 1, 1, 1, 3, :));
plot(carsMax,'--')
plot(carsAverage)
plot(carsMin,'--')

xlabel('Kellonaika (h)')
ylabel('Autoja')
legend('maksimi','keskiarvo','minimi')
end

