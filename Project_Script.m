%/////////////////////////////////////////////////////////////////////////////////
% ECE 497
% Gillian Holman, Lucy Rukstales, Jacob Huff
% Acceleration to 1/4 mile
% 11/1/2020
%////////////////////////////////////////////////////////////////////////////////

clear all;
close all;
clc;

%% Declare bike parameters and constants
Prrated = 65280;            % Rated power [W]
Trrated = 210*1.3563;       % Rated torque [N-m]
rw = 0.3;                   % Front wheel radius [m] - (back tire is 0.32 m)
Ngb = 2;                    % Gearbox ratio
ngb = 0.97;                 % Gearbox efficiency
m = 197;                    % [kg]
RiderMass = 68;             % Estimate [kg]
meq = m + RiderMass;        % [kg]

%% EPA coast-down curve fitting parameters
A = 18.3;                   % [N]
B = 0;                      % Not applicable for electric motorcycles
C = 0.0282*12.96;           % [N/(km/h)^2] to [N/(m/s)^2]

%% Calculate rated velocity
wrrated = Prrated/Trrated;  % Rated rotor angular velocity [rad/s]
wmrated = wrrated/Ngb;      % Rated motor angular velocity [rad/s]
vmrated = wmrated*rw;       % Rated motor velocity [m/s]

%% Initialize vehicle velocity parameters
dT = 1e-3;                  % Time step [s]
v(1) = 0;                   % Initial vehicle velocity [m/s]
t(1) = 0;                   % Initial time [s]
dist(1) = 0;                % Initial distance [m]
n = 1;                      % Iterator

%% Accelerate until travel 1/4 miles
while (dist < (0.25*1609.34))
    if (v(n) < vmrated)     % Constant Torque mode
        v(n+1) = v(n) + dT*(Ngb*ngb*Trrated - rw*(A + B*v(n) + C*(v(n))^2))/(rw*meq);
        T(n+1) = Trrated;
        P(n+1) = Trrated*v(n+1)*Ngb/rw;
    else                    % Constant Power mode
        v(n+1) = v(n) + dT*(ngb*((Prrated*rw)/(v(n))) - rw*(A + B*v(n) + C*(v(n))^2))/(rw*meq);
        P(n+1) = Prrated;
        T(n+1) = P(n+1)*rw/v(n+1)/Ngb;
    end
    t(n+1) = t(n) + dT;
    dist = trapz(t(1:length(v)), v);
    n = n + 1;
end
distFinal = trapz(t, v)     % Total distance travelled [m]
v_mph = ((v*3600)/1609.34);     % [m/s] to [mph]

%% Plot Power and Torque vs. Speed
figure
yyaxis right
plot(v*3.6,P/1000)
title("Power and Torque vs. Speed")
xlabel('Speed [km/h]')
ylabel('Power [kW]')
yyaxis left
plot(v*3.6,T)
ylabel('Torque [N-m]')

%% Plot speed vs. time
figure
plot(t, v*3.6)
title("Speed vs. Time")
xlabel('Time [s]')
ylabel('Velocity [km/h]')
t(end) %time it takes to complete the quarter mile
