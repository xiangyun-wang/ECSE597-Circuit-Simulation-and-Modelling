% Chebychev filter

InitiateCircuit;
% Specify component values. This is done only for clarity.
% The values could have been entered directly in the netlist below.
R1a = 9606;
R1b = 23280;
R2 = 6800;
C1 = 94.9e-9;
C2 = 20.5e-9;

C3 = 15e-9;
C4 = 15e-9;
R3 = 9304;
R4 = 9304;
Rq = 52107;
Rg = 9304;
r = 20000;

% A, the opamp gain, can be specified here or before calling this function
% A = 50; %OpAmp gain 


% Netlist is below. Output is node 10.
vol('V1','1','0','type', 'AC','AMPLITUDE',1);
res('R1a', '1','2',R1a);
res('R1b', '2','0',R1b);
res('R2','2','3',R2);
res('Rg','4','5',Rg);
res('Rq','5','6',Rq);
res('R4','6','7',R4);
res('r1','8','9',r);
res('r2','9','10',r);
res('R3','5','10',R3);

cap('C1','2','4',C1);
cap('C2','3','0',C2);
cap('C3','5','6',C3);
cap('C4','7','8',C4);


opamp('O1','4','3','4')
opamp('O2','6','0','5')
opamp('O3','8','0','7')
opamp('O4','10','0','9')