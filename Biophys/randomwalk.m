% This was designed to identify when a particle moving under Brownian motion would reach a certain distance away from the origin - 
% a popular question in cell molecular biology.
tmax = 4000;
nmax = 100;
dt =.1;
D = .1;

xs = zeros(tmax, nmax);
ys = zeros(tmax, nmax);
zs = zeros(tmax, nmax);

rs = zeros(tmax, nmax);
ths = zeros(tmax, nmax);
phs = zeros(tmax, nmax);


for n=1:nmax
   for t=2:tmax
       xs(t,n) = xs(t-1,n) + normrnd(0, 2*D*dt);
       ys(t,n) = ys(t-1,n) + normrnd(0, 2*D*dt);
       zs(t,n) = zs(t-1,n) + normrnd(0, 2*D*dt);
       
      
    
    
   n
   end
end

rs = (xs.^2 + ys.^2 + zs.^2).^(1/2);
ss = sqrt(xs.^2 +ys.^2);
phs = atan2d(ys, xs) + 360*ys<0;
ths = atan2d(zs, ss);


%c = [linspace(1,0,1000)', zeros(1,1000)', linspace(0,1,1000)']; % in RGB
%scatter3(xs(:,3),ys(:,3),zs(:,3),20,c);

% code to make first passes work
passed = rs>1;
isone = passed ==1;
firstpass = isone & cumsum(isone,1)==1;
[times, ~] = find(firstpass);