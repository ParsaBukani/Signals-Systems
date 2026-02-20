clear; clc; close all;


ts  = 1e-9;    
T   = 1e-5;    
tau = 1e-6;     

t = 0:ts:T;    

x = double(t <= tau);

plot(t, x); xlabel('t (s)'); ylabel('x(t)'); 
title('Transmitted pulse signal');