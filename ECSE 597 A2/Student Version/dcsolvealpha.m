function Xdc = dcsolvealpha(Xguess,alpha,maxerr)
% Compute dc solution using newtwon iteration for the augmented system
% G*X + f(X) = alpha*b
% Inputs: 
% Xguess is the initial guess for Newton Iteration
% alpha is a paramter (see definition in augmented system above)
% maxerr defined the stopping criterion from newton iteration: Stop the
% iteration when norm(deltaX)<maxerr
% Oupputs:
% Xdc is a vector containing the solution of the augmented system

global elementList 
[Bdc, Bac] = makeBvector;
G = makeGmatrix;

delta_x = zeros(size(Xguess));
Xdc = Xguess;
while (1)
    F = makeFvect(Xdc);
    J = make_nlJacobian(Xdc);
    phi = G * Xdc + F - alpha * Bdc;
    dphi = G + J;
    %[L,U,P] = lu((-1)*dphi);
    %y = L\(P*dphi);
    %delta_x = U\y;% 
    delta_x = ((-1) * dphi)\phi;
    Xdc = Xdc + delta_x;
    %norm(delta_x)
    if norm(full(delta_x)) < maxerr
        break;
    end
end
