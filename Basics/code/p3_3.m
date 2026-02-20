clear; clc; close all;

ts  = 1e-9;    
T   = 1e-5;    
tau = 1e-6; 
c   = 3e8;    
R   = 450;   
alpha = 0.5;  

t = 0:ts:T;  
delay = 2*R/c;               

x = double(t <= tau);
y = alpha * double((t - delay) <= tau & (t - delay) >= 0);

[r,lags] = xcorr(y, x);              
[d,k]    = max(r);                    % peak index
delay_hat = lags(k)*ts;               % convert to seconds
distance     = c*delay_hat/2

plot(lags*ts, r, 'k', 'LineWidth', 1.5, 'Color', 'green');
xlabel('Lag (s)'); ylabel('Correlation');
title('Cross-correlation');