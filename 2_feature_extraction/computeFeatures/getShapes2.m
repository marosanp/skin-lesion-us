function s = getShapes2(mask)

stats = regionprops(mask,'PerimeterOld','MajorAxisLength',...
    'MinorAxisLength','Area','Centroid','Orientation');

s.perim = stats.PerimeterOld;
s.majoraxis = stats.MajorAxisLength;
s.minoraxis = stats.MinorAxisLength;
center = stats.Centroid;
ori = stats.Orientation;
Cellipse = pi*((s.majoraxis+s.minoraxis)+3*(s.majoraxis-s.minoraxis)^2/(10*(s.majoraxis+s.minoraxis)+sqrt(s.majoraxis^2+14*s.majoraxis*s.minoraxis+s.minoraxis^2))); %not used here

%% 2 - Circularity
s.A = stats.Area;
s.Circularity = 4*pi*s.A/s.perim^2;

%% 4 - Elongation
%http://milos.stojmenovic.com/Publications_files/elongation-JMIV.pdf
% m20 = moment(mask, mask, 2,0);
% m02 = moment(mask, mask, 0,2);
% m11 = moment(mask, mask, 1,1);
% s.ElongationAll = (m20 + m02 + sqrt(4*m11^2+(m20-m02)^2))/...
%     (m20 + m02 - sqrt(4*m11^2+(m20-m02)^2));

%% Curvature

B = bwboundaries(mask);
B = B{1};
B = B(1:end-1,:);
bim = zeros(size(mask));
bim(sub2ind(size(mask), B(:,1), B(:,2))) = 1;
angs  = zeros(size(B,1),1);
d = 3;
for I = 1:size(B,1)
    P1 = B(max(1,mod(I-d - 1,size(B,1))+1),:);
    P2 = B(max(1,mod(I+d -1 ,size(B,1))+1),:);
    P = B(I,:);
    v1 = P-P1;
    v2 = P-P2;
    angs(I) = acosd(dot(v1, v2) / (norm(v1) * norm(v2)));
    if isnan(angs(I))
        angs(I) = 180;
    end
end
curv  = zeros(size(B,1),1);
for I = 1:size(B,1)
    a1 = angs(max(1,mod(I-d -1,size(B,1))+1),:);
    a2 = angs(max(1,mod(I+d -1,size(B,1))+1),:);
    P1 = B(max(1,mod(I-d -1,size(B,1))+1),:);
    P2 = B(max(1,mod(I+d -1,size(B,1))+1),:);
    curv(I) = (a2-a1)/norm(P1-P2)^2;%????????????????????
end

s.curv = curv;

% 
% %% 

phi = linspace(0,2*pi,size(B,1));
cosphi = cos(phi);
sinphi = sin(phi);

xbar = center(1);
ybar = center(2);

theta = pi*ori/180;
R = [ cos(theta)   sin(theta)
     -sin(theta)   cos(theta)];

xy = [s.majoraxis*cosphi/2; s.minoraxis*sinphi/2];
xy = R*xy;

x = xy(1,:) + xbar;
y = xy(2,:) + ybar;

% imshow(mask)
% hold on
% plot(x,y,'r','LineWidth',2);

dist = zeros(size(B,1),1);
for I = 1:size(B,1)
    Px = B(I,2);
    Py = B(I,1);
    dist(I) = min((Px-x).^2 + (Py-y).^2);
end
dist = sqrt(dist);

s.dist = dist/(s.minoraxis*s.majoraxis);




