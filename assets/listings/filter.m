% Low-pass Butterworth filter design
fc = 1000;               % Cutoff frequency (Hz)
order = 4;               % Filter order
[b, a] = butter(order, 2*pi*fc, 's');

% Frequency response
f = logspace(1, 5, 500);
H = freqs(b, a, 2*pi*f);

figure;
semilogx(f, 20*log10(abs(H)));
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
title('Butterworth Low-Pass Filter');
grid on;
