function [tpoints, X]= nl_BE_method(tEnd,h)
% This function uses BACKWARD EULER method to compute the transient reponse
% of a NONLINEAR circuit.
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


tpoints = 0:h:tEnd; 
Gmat = makeGmatrix;
Cmat = makeCmatrix;
%out_NodeNumber = getNodeNumber(outNode) ;
[row,~] = size(Gmat);
X_n = zeros(row);
X_n1 = X_n;
% x_n+1 = x_n + hx_n+1_dot
% x_n+1_dot = (x_n+1 - x_n)/h
% Gx_n+1 + C
for I=1:length(tpoints)
    % make Bvector at time tpoints(I)
    
    Btr = makeBt(tpoints(I));
    
    % you can write your code here
    while (1)
        F = makeFvect(X_n1);
        J = make_nlJacobian(X_n1);
        phi = (Gmat+Cmat/h) * X_n1 + F - (Btr + (Cmat/h)*X_n);
        dphi = (Gmat+Cmat/h) + J;

        delta_x = ((-1) * dphi)\phi;

        % dX(iteration) = norm(delta_x);
        X_n1 = X_n1 + delta_x;
        if norm(delta_x) < 0.0001
            break;
        end
        iteration = iteration + 1;
    end

    X(:,I) = X_n;
    X_n = X_n1;
    

end 

end
