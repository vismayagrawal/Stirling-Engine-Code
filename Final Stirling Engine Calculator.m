%% Details of the variables
% CV specific heat at constant volume (J/kg K)
% e regenerator effectiveness
% ES Stirling engine thermal efficiency
% K factor defined by Eq. (9)
% k specific heat ratio
% kSH VSH/VS is hot space dead volume ratio
% kSR VSR/VS is regenerator dead volume ratio
% kSC VSC/VS is cold space dead volume ratio
% kSDP VS/(VDCVP) is total dead volume to total volume ratio
% kST VS/V1 is total dead volume to total volume ratio
% m total working fluid mass contained in the engine (kg)
% p absolute pressure (N/m2)
% pm cycle mean effective pressure (N/m2)
% Qin total heat added from an external source to the cycle (J)
% Qout total heat rejected from the cycle to an external sink (J)
% R gas constant (J/kg K)
% T3 working fluid temperature in the hot space (K)
% T30 working fluid temperature at regenerator outlet (K)
% T1 working fluid temperature in the cold space (K)
% T10 working fluid temperature at regenerator inlet (K)
% TR effective working fluid temperature in regenerator dead space (K)
% TC cooler temperature (K)
% TH heater temperature (K)
% VSH hot-space dead volume (m3)
% VSR regenerator dead volume m3
% VSC cold-space dead volume (m3)
% VS total dead volume (m3)
% VD displacer swept volume (m3)
% VP power piston swept volume (m3)
% Wnet engine network (J)

%% Code Start

% Defining Variables

Vs = [0: 0.00001 : 0.02];     % VS total dead volume (m3)

T1 = 303;                     % T1 working fluid temperature in the cold space (K)
T3 = 400;                     % T3 working fluid temperature in the hot space (K)
TR = (T1 + T3)/2;             % TR effective working fluid temperature in regenerator dead space (K)

% Assume ratio Vp/Vd is 2/3
Vd = [0: 0.00001 : 0.02];     % VD displacer swept volume (m3)
Vp = 2*Vd./3;                 % VP power piston swept volume (m3)
Vc = Vd + Vp;                 % VSC cold-space dead volume (m3)
% Vt = Vd + Vp + Vs 

% these given are in pdf  
kSH = 0.2;                    % kSH VSH/VS is hot space dead volume ratio
kSR = 0.6;                    % kSR VSR/VS is regeneraeZ0, 0.2, 0.4, 0.6, 0.8, 1tor dead volume ratio
kSC = 0.2;                    % kSC VSC/VS is cold space dead volume ratio

% K is factor defined by this equation
K = (kSH/T3 + kSR/TR + kSC/T1) .* Vs;

E = 0.8;                      % e regenerator effectiveness, assume 80%
k = 1.4;                      % k specific heat ratio = Cp/Cv


%% Calculations for stirling engine

% gas variable calculations
m = 352.96 .* (K + Vc/T1);
R = 287;

% looping on Vd, and getting output power and efficiency for range of Vs
for i = 1:length(Vd)
    % Net work in per cycle
    Wnet(i,:) = k.*m(i).*R.*(E./10000).*(T3.*log((Vd(i)+Vp(i)+(K.*T3))./(Vd(i)+(K.*T3)))-T1.*log(Vd(i)+Vp(i)+(K.*T1))./(Vd(i)+(K.*T1)));
    % Net power assuming angular frequency of 800 rad/min
    Pnet(i,:) = 800 .* Wnet(i,:) ./ 360;  
    % Thermal efficiency
    Es(i,:)= E.*(T3.*log((Vd(i)+Vp(i)+(K.*T3))./(Vd(i)+(K.*T3)))-T1.*log((Vd(i)+Vp(i)+(K.*T1))./(Vd(i)+(K.*T1))))./(T3.*log((Vd(i)+Vp(i)+(K.*T3))./(Vd(i)+(K.*T3))+(T3-T1).*(1-E)./(k-1))).*10;
end

%% Plotting

% plotting 3D graph of Net power vs volumes
mesh(Vd, Vs, flip(flip(Pnet,2)));
title('Plot for Power Calculations (units in SI)');
xlabel('Displacer swept volume Vd');
ylabel('Total dead volume Vs');
zlabel('Net Power Pnet');

% plotting 3D graph of Efficiency vs volumes
figure; mesh(Vd, Vs, flip(flip(Es,2)));
title('Plot for Efficiency Calculations (units in SI)');
xlabel('Displacer swept volume Vd');
ylabel('Total dead volume Vs');
zlabel('Efficiency Es');


