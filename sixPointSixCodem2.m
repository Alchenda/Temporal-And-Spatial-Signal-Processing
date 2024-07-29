close all
%image parameters
W = 400;
H = 400;
% object parameters
rho = 200;
A = 0.4;
B = 0.2;
alpha = pi /10;
xo = 0.3;
yo = 0.5;
% backprojection parameters
ntheta = 100;
srange = 2;
ns = 100;
% generate projections
[projmat, svals, thetavals] = ...
    ellipseprojmat(A, B, ntheta, ns, srange, rho, alpha, xo, yo); % solve using backprojection
[b] = bpsolve(W, H, projmat, svals, thetavals);
% scale for image display
b = b/max(max(b)); b = b*255;
bi = uint8(b);
figure(1);
clf
image(bi); 
colormap(gray(256)); 
box('on');
axis('off');
shg;
saveas(gcf,'CompileData.png');












function [P] = ellipseproj(A, B, rho, theta, s, alpha, xo, yo) 
gamma = atan2(yo, xo);
d = sqrt( xo * xo + yo * yo);
thetanew = theta - alpha;
snew = s - d * cos(gamma - theta);
% use translated/rotated values
s = snew;
theta = thetanew;
% find a^2 (theta)
ct = cos(theta);
st = sin(theta);
a2 = A*A*ct*ct + B*B*st*st;
atheta = sqrt(a2);
% return value if outside ellipse 
P = 0;
if( abs(s) <= atheta )
    % inside ellipse
    P = 2 * rho * A * B / a2 * sqrt(a2 - s * s); 
end
end %added
function [projmat, svals, thetavals] = ... 
    ellipseprojmat(A, B, ntheta, ns, srange, rho, alpha, xo, yo)
thetamin = 0;
thetamax = pi;
% each row is a projection at a certain angle 
projmat = zeros(ntheta, ns);
smin = -srange;
smax = srange;
dtheta = pi/(ntheta - 1);
ds = (smax - smin)/(ns - 1);
svals = smin:ds:smax;
thetavals = thetamin:dtheta:thetamax;
pn = 1;
for theta = thetavals
    % calculate all points on the projection line 
    P = zeros(ns, 1);
    ip = 1;
    for s = svals
        % simple ellipse
        [p] = ellipseproj(A, B, rho, theta, s, alpha, xo, yo); 
        P(ip) = p;
        ip = ip + 1;
    end
    % save projection as one row of matrix 
    projmat(pn, :) = P';
    pn = pn + 1;
end
end %added
function [b] = bpsolve(W, H, projmat, svals, thetavals) 
ntheta = length(thetavals);
ns = length(svals);
srange = svals(ns);
b = zeros(H, W);
for iy = 1:H
    for ix = 1:W
        x = 2 * (ix - 1)/(W - 1) - 1;
        y = 1 - 2 * (iy - 1)/(H - 1);
        % projmat is the P values, each row is P(s) for a given theta 
        bsum = 0;
        for itheta = 1:ntheta
            theta = thetavals(itheta);
            s =x*cos(theta) + y*sin(theta);
            is = (s + srange)/(srange*2)*(ns - 1) + 1; 
            is = round(is);
            if(is < 1)
                is = 1; 
            end
            if(is > ns) 
                is = ns;
            end
            Ptheta = projmat(itheta, is);
            bsum = bsum + Ptheta; 
        end
        b(iy, ix) = bsum; 
    end
end
end %added