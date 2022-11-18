function [tpoints, y]= BE_method(tEnd,h, outNode)
% This function uses BACKWARD EULER method to compute the transient reponse
% of the circuit.
%Inputs: 1. tEnd:  The simulation starts at time = 0s  and ends at time =
%                  tEND s.
%        2. h: length  of step size.
%        3. outNode: is the node for which the transient is required.
%Output:  1. tpoints: list of time points.
%         2. y:  is the transient response at output node.
%
%Note: The function stub provided above is just an example. You can modify the 
%      in function in any fashion. 
%--------------------------------------------------------------------------

global elementList
out_NodeNumber = getNodeNumber(outNode) ;

tpoints = 0:h:tEnd; 
Gmat = makeGmatrix;
Cmat = makeCmatrix;


for I=1:length(tpoints)
    % make Bvector at time tpoints(I)
    Btr = makeBt(tpoints(I));
    
    % you can write your code here

end 
     
    
end     