function [shape] = shapeindex(I, sigma)
% [iso, theta ] = isophotes( I, alpha );
%
% Inputs:     I     -  Luminance of the input image [0 255]
%             sigma -  threshold for avoiding NaNs
%               
% Returns:    shape -  shape index   [-pi pi]

I = mat2gray(I);
shape = zeros(size(I));
iso = zeros(size(I));
flow = zeros(size(I));

[Ix, Iy] = gradient(I);
[Ixx, Ixy] = gradient(Ix);
[Iyx, Iyy] = gradient(Iy);

magnitude = sqrt(Ix.^2 + Iy.^2);
T = magnitude~=0;
iso(T) = (Ixx(T).*Iy(T).^2 + Iyy(T).*Ix(T).^2 - 2*Ix(T).*Iy(T).*Ixy(T))./magnitude(T).^3;
flow(T) = (Ix(T).*Iy(T).*(Ixx(T)-Iyy(T)) + Ixy(T).*(Iy(T).^2 - Ix(T).^2))./magnitude(T).^3;

T = (abs(iso)>sigma)&(abs(flow)>sigma);
shape(T) = atan((iso(T)+flow(T))./(iso(T)-flow(T)));
shape = mat2gray(shape);



