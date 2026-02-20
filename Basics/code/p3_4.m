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
y = alpha * double((t - delay) >= 0 & (t - delay) <= tau);

noiseStd = linspace(0, 4, 30);  
trials   = 100;                      
err      = zeros(size(noiseStd));    

for i = 1:numel(noiseStd)
    e = zeros(trials,1);
    for j = 1:trials
        y_noisy = y + noiseStd(i)*randn(size(y));
        [r,lags] = xcorr(y_noisy, x);
        [~,k] = max(r);
        delay_hat = lags(k)*ts;
        R_hat = c*delay_hat/2;
        e(j) = abs(R_hat - R);
    end
    err(i) = mean(e);                
end

figure;
plot(noiseStd, err, 'LineWidth', 2); hold on
yline(10, 'r--', 'LineWidth', 1.5);          % accepted error = 10 m
grid on
xlabel('Noise std'); ylabel('Mean distance error (m)');
title('Mean Error vs Noise');
legend('Mean error','Maximum Accepted Error = 10 m');
