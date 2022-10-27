function [Xdc dX] = dcsolve(Xguess,maxerr)
% Compute dc solution using newtwon iteration
% input: Xguess is the initial guess for the unknown vector. 
%        It should be the correct size of the unknown vector.
%        maxerr is the maximum allowed error. Set your code to exit the
%        newton iteration once the norm of DeltaX is less than maxerr
% Output: Xdc is the correction solution
%         dX is a vector containing the 2 norm of DeltaX used in the 
%         newton Iteration. the size of dX should be the same as the number
%         of Newton-Raphson iterations. See the help on the function 'norm'
%         in matlab. 
global elementList

[Bdc, Bac] = makeBvector;
G = makeGmatrix;
iteration = 1;
delta_x = zeros(size(Xguess));
Xdc = Xguess;
while (1)
    F = makeFvect(Xdc);
    J = make_nlJacobian(Xdc);
    phi = G * Xdc + F - Bdc;
    dphi = G + J;
    delta_x = ((-1) * dphi)\phi;
    dX(iteration) = norm(delta_x);
    Xdc = Xdc + delta_x;
    if norm(delta_x) < maxerr
        break;
    end
    iteration = iteration + 1;
end

