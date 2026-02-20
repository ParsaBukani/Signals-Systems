clc;
clear;
close all;

%% Global Parameters
fc = 5;               
fs = 100;              
t_start = 0;           
t_end = 1;             
t = t_start : 1/fs : (t_end - 1/fs);

%% Exercise 1.1

x_tx = cos(2*pi*fc*t);

figure;
plot(t, x_tx, 'LineWidth', 1.5);
grid on;
xlabel('Time (s)');
ylabel('Amplitude');
title('Exercise 1.1: Transmitted Radar Signal');

%% Exercise 1.2

R = 250;              
alpha = 0.5;           
c = 3e5;              

% Doppler frequency and delay
v = 180 / 3.6;   
beta = 0.3;       
fd = beta * v;    
td = (2 * R) / c;     

y_rx = alpha * cos(2*pi*(fc + fd)*(t - td));

figure;
plot(t, y_rx, 'LineWidth', 1.5);
grid on;
xlabel('Time (s)');
ylabel('Amplitude');
title('Exercise 1.2: Received Radar Signal with Doppler and Delay');


%% Exercise 1.3

f = 0 : (fs / length(t)) : (fs - fs / length(t));

y_fourier = fft(y_rx);

[~, indx] = max(abs(y_fourier));
fd = f(indx) - fc;
v_est = fd / beta * 3.6

tol = 1e-6;
y_fourier(abs(y_fourier) < tol) = 0;

td = abs(angle(y_fourier(indx))) / (2*pi*(fc + fd));

R_est = td * c / 2

%% Exercise 1.4

noise_levels = [0 0.005 0.01 0.02 0.05 0.1];

f = 0 : (fs / length(t)) : (fs - fs / length(t));

disp('NoiseStd    v_est(km/h)    R_est(km)')

for sigma = noise_levels

    y_noisy = y_rx + sigma * randn(1, length(y_rx));

    Y = fft(y_noisy);

    [~, indx] = max(abs(Y));
    fd = f(indx) - fc;
    v_est = fd / beta * 3.6;

    tol = 1e-6;
    Y(abs(Y) < tol) = 0;

    td = abs(angle(Y(indx))) / (2*pi*(fc + fd));
    R_est = td * c / 2;

    fprintf('%7.3f      %8.2f        %8.2f\n', sigma, v_est, R_est)

end

%% Exercise 1.5

beta = 0.3;
c = 3e5;
rou = 2 / c;

% first target
alpha_1 = 0.5;
v_1 = 180 / 3.6;
R_1 = 250;
fd_1 = beta * v_1;
td_1 = rou * R_1;
y_1 = alpha_1 * cos(2*pi*(fc + fd_1)*(t - td_1));

% second target
alpha_2 = 0.6;
v_2 = 216 / 3.6;
R_2 = 200;
fd_2 = beta * v_2;
td_2 = rou * R_2;
y_2 = alpha_2 * cos(2*pi*(fc + fd_2)*(t - td_2));

% received signal (sum of echoes)
y_rx = y_1 + y_2;

figure;
plot(t, y_rx, 'LineWidth', 1.5);
grid on;
xlabel('Time (s)');
ylabel('Amplitude');
title('Exercise 1.5: Received Signal from Two Targets');


%% Exercise 1.6

f = 0 : (fs / length(t)) : (fs - fs / length(t));
N = length(t);

y_fourier = fft(y_rx);

% object 1
[~, indx] = max(abs(y_fourier));
fd = f(indx) - fc;
v1_est = fd / beta * 3.6

tol = 1e-6;
y_fourier(abs(y_fourier) < tol) = 0;

td = abs(angle(y_fourier(indx))) / (2*pi*(fc + fd));
R1_est = td * c / 2

conj_indx = mod(N - indx + 1, N) + 1;
y_fourier([indx conj_indx]) = 0;

% object 2
[~, indx] = max(abs(y_fourier));
fd = f(indx) - fc;
v2_est = fd / beta * 3.6

tol = 1e-6;
y_fourier(abs(y_fourier) < tol) = 0;

td = abs(angle(y_fourier(indx))) / (2*pi*(fc + fd));
R2_est = td * c / 2
