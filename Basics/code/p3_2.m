clear; clc; close all;

ts  = 1e-9;    
T   = 1e-5;    
tau = 1e-6;     

t = 0:ts:T;    

x = double(t <= tau);

plot(t, x, 'LineWidth', 2.5); hold on;

c   = 3e8;    
R   = 450;   
alpha = 0.5;  

delay = 2*R/c;               
y = alpha * double((t - delay) <= tau & (t - delay) >= 0);

plot(t, y, 'r--', 'LineWidth', 2);
xlabel('t (s)'); ylabel('amplitude');
legend('x(t)','y(t)'); title('Transmitted and Received Pulses');