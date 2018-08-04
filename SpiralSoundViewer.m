clear; close all;

df = 10; % Hz
dt = .1; % s

filename = 'The_Entertainer_-_Scott_Joplin.wav';
[y, Fs] = audioread(filename);
y = y(:,1);

nfft = 2^nextpow2(Fs/df);
hop = round(dt*Fs);
win = gausswin(nfft);

stftMag = abs(stfft(y, win, hop)).^2;
f = (Fs*(0:(nfft/2))/nfft).';

theta = 2*pi/log(2).*log(f./(f(2)));
rho = 10 - theta./2./pi;

nC = 1e2;
rHsv = [zeros(nC, 1), linspace(0, 1, nC).', ones(nC, 1)];
colormap(hsv2rgb(rHsv));

sz = 30.*ones(nnz(rho >= 0), 1);
c = round(stftMag(rho >= 0,:)./max(stftMag(rho >= 0,:), [], 1).*nC);

tickLabels = {'', '', '' , '', '', ''};
frames = struct('cdata', [], 'colormap', []);
for frameInd = 1:nnz(rho >= 0)
    polarscatter(theta(rho >= 0), rho(rho >= 0), sz, c(:,frameInd).', 'o', 'filled', 'MarkerFaceAlpha', .5);
    rlim([0, 10]); rticklabels(tickLabels);
    colorbar('TickLabels', tickLabels);
    ax = gca;
    ax.FontWeight = 'bold';
    ax.GridAlpha = .5;
    frames(frameInd) = getframe(gcf);
end

[filepath, name, ext] = fileparts(filename);
v = VideoWriter([name, ' (Spiral Viewer).avi', 'Uncompressed AVI']); 
v.FrameRate = round(1/dt);
v.Quality = 100;
open(v); writeVideo(v, frames); close(v);
