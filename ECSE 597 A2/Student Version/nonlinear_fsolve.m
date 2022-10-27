function r = nonlinear_fsolve(fpoints ,out)

% This function  Obtains frequency response of the nonlinear function
% global variables G C b bac
% Inputs: 1. fpoints is a vector containing the fequency points\
%         2. out is the node name of the output node. 
             
% Outputs: r is a vector containing the value of
%            of the response at the points fpoint

global  elementList

outNodeNumber = getNodeNumber(out);

n = elementList.n;
guess = zeros(n,1);

G = makeGmatrix;
C = makeCmatrix;
[Bdc, Bac] = makeBmatrix;
Xdc = dcsolve(guess,0.0001);
Jdc = make_nlJacobian(Xdc);
[~,f_size] = size(fpoints);
f_responses = zeros(1,f_size);
B_fr = zeros(n,1);

for m = 1:n
    if (Bac(m,1) ~= 0) 
        B_fr(m,1) = 1;
    end
end

for i = 1:f_size
    tmp = (G+2*pi*1i*fpoints(1,i)*C+Jdc)\B_fr;
    f_responses(1,i) = tmp(outNodeNumber,1);
end

r = f_responses;