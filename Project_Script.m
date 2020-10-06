clear
clc
% Tesla Model S Parameters from Table 2.1
Prrated=270000;
Trrated=440;
r=0.315;%0.352
ng=9.73;
m=2155;
A=177.2;
B=1.445;
C=0.354;
eta=0.97;

wrrated=Prrated/Trrated;
wmrated=wrrated/ng;
vmrated=wmrated*r;
dT=5e-4;

v(1)=0;
t(1)=0;
dist(1)=0;
n=1;
while dist<(0.25*1609.34) %convert miles to meters
    if (v(n)<vmrated)
        v(n+1)=v(n)+dT*(ng*eta*Trrated-r*(A+B*v(n)+C*(v(n))^2))/(r*m);
    else
        v(n+1)=v(n)+dT*(eta*((Prrated*r)/(v(n)))-r*(A+B*v(n)+C*(v(n))^2))/(r*m);
    end
    t(n+1)=t(n)+dT;
    dist(n)=trapz(v,t(1:length(v)));
    n=n+1;
end
distFinal=trapz(v,t)
v=((v*3600)/1609.34); %convert m/s to mph
plot(t,v)
t(end) %time it takes to complete the quarter mile
