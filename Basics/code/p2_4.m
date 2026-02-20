clear; clc; close all;

function [alpha, beta] = func(x, y)
N = length(x);
sumx  = sum(x);
sumy  = sum(y);
sumxy = sum(x.*y);
sumx2 = sum(x.^2);

alpha = (N*sumxy - sumx*sumy) / (N*sumx2 - sumx^2);
beta  = (sumy - alpha*sumx) / N;
end

load p2.mat
[a,b] = func(x,y)



% Checking if the function is correct

x2 = linspace(0,10,100);
alpha_true = 3; beta_true = 1;
y2 = alpha_true*x2 + beta_true + 0.1*randn(size(x2));
[alpha_test,beta_test] = func(x2,y2)
