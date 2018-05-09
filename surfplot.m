function surfplot(pair, data, titl)
global defaults len1 len2 len3 len4 k_s errorsigma_s lotsize_s weight_s
figure
switch pair
    case 1
        n = defaults(3);
        o = defaults(4);
        z = squeeze(data(:, :, n, o));
        [x, y] = meshgrid(k_s, errorsigma_s);
        xlbl = 'k';
        ylbl = 'errorsigma';
    case 2
        m = defaults(2);
        o = defaults(4);
        z = squeeze(data(:, m, :, o));
        [x, y] = meshgrid(k_s, lotsize_s);
        xlbl = 'k';
        ylbl = 'lotsize';
    case 3
        m = defaults(2);
        n = defaults(4);
        z = squeeze(data(:, m, n, :));
        [x, y] = meshgrid(k_s, weight_s);
        xlbl = 'k';
        ylbl = 'weight';
    case 4
        l = defaults(1);
        o = defaults(4);
        z = squeeze(data(l, :, :, o));
        [x, y] = meshgrid(errorsigma_s, lotsize_s);
        xlbl = 'errorsigma';
        ylbl = 'lotsize';
    case 5
        l = defaults(1);
        n = defaults(3);
        z = squeeze(data(l, :, n, :));
        [x, y] = meshgrid(errorsigma_s, weight_s);
        xlbl = 'errorsigma';
        ylbl = 'weight';
    case 6
        l = defaults(1);
        m = defaults(2);
        z = squeeze(data(l, m, :, :));
        [x, y] = meshgrid(lotsize_s, weight_s);
        xlbl = 'lotsize';
        ylbl = 'weight';

    otherwise
        disp('pair needs to be 1-6')
    end

    surf(x, y, z')
    xlabel(xlbl)
    ylabel(ylbl)
    title(titl)
    colorbar
end
