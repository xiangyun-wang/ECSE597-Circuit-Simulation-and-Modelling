function [tpoints,y]= Trapezoidal_method(tEnd,h, outNode)
% This function uses Trapezoidal method to compute the transient reponse
% of the circuit.
%Inputs: 1. tEnd:  The simulation starts at time = 0s  and ends at 
%                 time = tEND s.
%        2. h: length  of step size.
%        3. outNode: is the node for which the transient is required.
%Output:  1.y:  is the transient response at output Node.
%
%Note: The function stub provided above is just an example. You can modify the 
%      in function in any fashion. 
%--------------------------------------------------------------------------

global elementList

out_NodeNumber = getNodeNumber(outNode) ;

tpoints = 0:h:tEnd; 

Gmat = makeGmatrix;
Cmat = makeCmatrix;


[row,~] = size(Gmat);
X_n = zeros(row);
y(1) = 0;
for I=2:(length(tpoints))
    % make Bvector at time tpoints(I)
    Btr = makeBt(tpoints(I-1));
    Btr_1 = makeBt(tpoints(I));
    % you can write your code here
    X_n = inv((Gmat+(2/h)*Cmat))*(((2/h)*Cmat-Gmat)*X_n+Btr + Btr_1);
    y(I) = X_n(out_NodeNumber);
end 
     
    
end    