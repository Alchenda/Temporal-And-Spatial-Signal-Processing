N = 10,000;
x = randn(1, N);
n = 0:N -  1;
yc = 2.0 * sin(2*pi*n/(N -  1)*5);
% noise coupling—unknown transfer function
b = [1 0.8 -0.4  0.1];
v = filter(b, 1, x);
y = yc + v;
L = 5; % coefficient length
% Wiener optimal solution
% reshape signal vectors in order to calculate covariances 
ym = reshape(y, L,N/L); % the output (y) vector
xm = reshape(x, L, N/L); % the input (x) vector
 xv = xm(1 ,:);
R = (xm * xm')/(N/L); 
r = (ym * xv')/(N/L); % optimal weights 
wopt = inv(R) *r;
% y vector at intervals corresponding % to the start of the xm’s above % E(X  XˆT)
% E(y X)
% noise estimate
vest = filter(wopt, 1, x);
% error = signal — noise estimate 
e = y -  vest;
wopt

