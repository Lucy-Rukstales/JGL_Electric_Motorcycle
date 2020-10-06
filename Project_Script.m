clear
clc

Prrated=65280; % Rated Power in W
Trrated=210*1.3563; %convert to Nm
r=0.3; %radius in m - front tire (back tire is 0.32 m)
ng=2;
m=197; %197kg
RiderMass=68; %approximately 150lb rider
meq=m+RiderMass;
A=18.3;
B=0;
C=0.0282*12.96;%(N/(km/h)^2) to (N/(m/s)^2)
eta=0.97;

wrrated=Prrated/Trrated;
wmrated=wrrated/ng;
vmrated=wmrated*r;
dT=1e-3;

v(1)=0;
t(1)=0;
dist(1)=0;
n=1;
while (dist<(0.25*1609.34)) %convert miles to meters
    if (v(n)<vmrated)
        v(n+1)=v(n)+dT*(ng*eta*Trrated-r*(A+B*v(n)+C*(v(n))^2))/(r*meq);
    else
        v(n+1)=v(n)+dT*(eta*((Prrated*r)/(v(n)))-r*(A+B*v(n)+C*(v(n))^2))/(r*meq);
    end
    t(n+1)=t(n)+dT;
    dist=trapz(t(1:length(v)),v);
    n=n+1;
end
distFinal=trapz(t,v)
v=((v*3600)/1609.34); %convert m/s to mph
plot(t,v)
xlabel('Time')
ylabel('Velocity')
t(end) %time it takes to complete the quarter mile
