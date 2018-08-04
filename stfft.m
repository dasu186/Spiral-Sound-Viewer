function res = stfft(input, win, hop)

    nfft = numel(win);
    num_segs = ceil((numel(input)-nfft)/hop);
    input = padarray(input, [(num_segs*hop+nfft)-numel(input), 0], 'post');
    
    res = zeros(nfft/2+1, num_segs+2);
    for k=1:num_segs
        ind = (k-1)*hop;
        ff = fft(win.*input(ind+1:ind+nfft), nfft);
        res(:, k) = ff(1:nfft/2+1);
    end
end