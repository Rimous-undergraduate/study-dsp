%% Nov 11 2026 Jaejun lee
%% Note
% This IIR filter code shows 
% 1. How does the transfer function looks line in freq.-domain
% 2. How the filter responds to sinusoidal inputs at selected frequencies
% The response is amplified near 0.41 and attenuated near pi, matching to the 1st graph(transfer function graph)
%% Code
w = 0:0.01:2*pi;                              % Frequency axis
[b0, b1, b2, a1, a2] = deal(0.1, 0.2, 0.1, 1.757, -0.921);  % Filter coefficients

Hnum = b0 + b1 * exp(-1j*w) + b2 * exp(-1j*2*w);  % Numerator of H(e^jw)
Hden = 1 - a1 * exp(-1j*w) - a2 * exp(-1j*2*w);    % Denominator of H(e^jw)
H = Hnum ./ Hden;                                  % Frequency response

sgtitle('IIR Filter Response')

subplot(3, 1, 1)                                   % First subplot
plot(w, abs(H));
title('Frequency Response')
xlabel('\omega')
ylabel('|H(e^{j\omega})|')
xlim([0 pi*2])
grid on

b = [b0, b1, b2];                                  % Numerator coefficients for filter()
a = [1, -a1, -a2];                                 % Denominator coefficients for filter()

n = 0:100;                                         % Time index
w_test = 0.41;                                     % Test frequency; Amplifying freq.

x = cos(w_test * n);                               % Input test signal
y = filter(b, a, x);                               % Filter output

subplot(3, 1, 2)                                   % Second subplot
stem(n, y);
title('Output for \omega = 0.41')
xlabel('n')
ylabel('y[n]')
grid on

subplot(3, 1, 3)                                   % Third subplot
w_test = pi;                                       % Second test frequency; Attenuating freq.
x = cos(w_test * n);                               % Input test signal
y = filter(b, a, x);                               % Filter output
stem(n, y);
title('Output for \omega = \pi')
xlabel('n')
ylabel('y[n]')
grid on