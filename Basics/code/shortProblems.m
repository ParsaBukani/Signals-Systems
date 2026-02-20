clear; clc; close all;


disp('1. Scalar variables:');
a = 10
b = 2.5e23
c = 2 + 3i
d = exp(1j * 2 * pi / 3)


disp('2. Vector variables:')
aVec = [3.14 15 9 26]
bVec = [2.71; 8; 28; 182]
cVec = 5:-0.2:-5
dVec = logspace(0, 1, 100)
eVec = 'Hello'


disp('3. Matrix variables:')
aMat = 2 * ones(9)
bMat = diag([1 2 3 4 5 4 3 2 1])
cMat = reshape(1:100, [10, 10])
dMat = nan(3, 4)
eMat = [13 -1 5; -22 10 -87]
fMat1 = floor(-3 + (6+1) * rand(5, 3))
fMat2 = randi([-3, 3], 5, 3)


disp('4. Scalar equations:')
x = 1 / (1 + exp(-(a-15)/6))
y = (sqrt(a) + nthroot(b, 5))^pi
z = log(real((c + d) * (c - d)) * sin(a*pi/3)) / (c * conj(c))


disp('5. Matrix equations')
xMat = (aVec * bVec) * (aMat^2)
yMat = bVec * aVec
zMat = det(cMat) * (aMat * bMat)'


disp('6. Common functions and indexing:')
cSum = sum(cMat)
eMean = mean(eMat, 2)
eMat(1, :) = [1 1 1]
cSub = cMat(2:9, 2:9)
lin = 1:20;    lin(2:2:20) = -lin(2:2:20)
r = rand(1, 5);    idx = find(r < 0.5);    r(idx) = 0; r


disp('7. Plotting multiple lines and colors: it is provided in the twoLinePLot.m script')
