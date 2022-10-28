function Xdc = dcsolvecont(n_steps,maxerr)
% Compute dc solution using newtwon iteration and continuation method
% (power ramping approach)
% inputs:
% n_steps is the number of continuation steps between zero and one that are
% to be taken. For the purposes of this assigments the steps should be 
% linearly spaced (the matlab function "linspace" may be useful).
% maxerr is the stopping criterion for newton iteration (stop iteration
% when norm(deltaX)<maxerr

global elementList

% size of MNA matrix
alpha = linspace(0,1,n_steps);
n = elementList.n;
Xdc = zeros(n,1);
for step = 1:n_steps
    Xdc = dcsolvealpha(Xdc,alpha(step),maxerr);
end