close all
clear all

global len1 len2 len3 len4 k_s errorsigma_s lotsize_s weight_s results correlations defaults
initialoccupancy = 10;
simulationlength = 30*6;
fines = 0;

k_s = 1:1:10;
errorsigma_s = 1:5:21;
lotsize_s = [50 100 150 200 250 300];
weight_s = 0.3:0.1:1.0;
defaults = [5, 2, 4, 5];
len1 = length(k_s);
len2 = length(errorsigma_s);
len3 = length(lotsize_s);
len4 = length(weight_s);
results = cell(len1, 1);
correlations = cell(len1, 1);
maxcount = cell(len1, 1); % Montako tuntia parkkipaikka on kokonaan taynna

myCluster = parcluster('local');
myCluster.NumWorkers = 8;
saveProfile(myCluster);

if isempty(gcp('nocreate'))
    parpool('local', 8);
end

parfor l=1:len1
    v = zeros(len2, len3, len4, 3, 24);
    cor = zeros(len2, len3, len4, 1);
    mc = zeros(len2, len3, len4, 1);
    k = k_s(l);
    for m=1:len2
        errorsigma = errorsigma_s(m);
        for n=1:len3
            lotsize = lotsize_s(n);
            for o=1:len4
                weight = weight_s(o);
                idx = (m-1)*len3*len4 + (n-1)*len4 + o;
                [vv, co] = parkki(k, weight, errorsigma, lotsize, initialoccupancy, simulationlength, fines, 0);
                v(m, n, o, :, :) = vv;
                cor(m, n, o) = co;
                mc(m, n, o) = length(find(vv(1, :) == lotsize));
            end
        end
    end
    results{l, 1} = v;
    correlations{l, 1} = cor;
    maxcount{l, 1} = mc;
end

resultsmat = zeros(len1, len2, len3, len4, 3, 24);
corrmat = zeros(len1, len2, len3, len4);
mcmat = zeros(len1, len2, len3, len4);
for l=1:len1
    resultsmat(l, :, :, :, :, :) = results{l};
    corrmat(l, :, :, :) = correlations{l};
    mcmat(l, :, :, :) = maxcount{l};
end

correlations = corrmat;
results = resultsmat;
maxcount = mcmat;

