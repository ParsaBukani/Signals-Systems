clear; clc; close all;

% (b)
figure;

% (c)
t = linspace(0, 2*pi, 1000);
plot(t, sin(t)); 
hold on;  
plot(t, cos(t), 'r--');

% (d)
xlabel('time (t)');
ylabel('value');
title('Sin and Cos functions');
legend('Sin','Cos');

% (e)
xlim([0 2*pi]);
ylim([-1.4 1.4]);
