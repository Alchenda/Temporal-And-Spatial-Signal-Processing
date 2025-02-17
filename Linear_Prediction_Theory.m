clear all;

N = 1000;
r = 0.9; %Angle of the pole
omega = pi/10; %Radius of the pole

p = r * exp(j * omega);
a = poly([p conj(p)]); %store the poles of the system
roots(a)

e = randn(N, 1); %System input
x = filter(1, a, e); %Response to said system input

%autocorrelations can now be calculated
R0 = sum(x .* x)/N;
R1 = sum(x(1:N - 1) .* x(2:N))/N;
R2 = sum(x(1:N - 2) .* x(3:N))/N;

%autocorrelation matrix and vector creation
R = [R0 R1; R1 R0];
r = [R1; R2];

%optimal predictor solution
w = inv(R) * r;

%predictor paramters used as filter
ahat = [1 ; -w];

%sample values
xhat = filter(1, ahat, e);
disp('a =');
disp(a);
disp('ahat =');
disp(ahat');

y = x(3:N) ;
M = [x( 2:N - 1) x(1:N - 2)] ;
w = inv(M' * M) * M' * y;
w = 1.7222 , -0.8297 