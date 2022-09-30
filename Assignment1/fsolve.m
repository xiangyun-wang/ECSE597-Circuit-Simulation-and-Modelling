function r = fsolve(Gmat, Cmat, fpoints ,out)
%  fsolve(fpoints ,out)
%  Obtain frequency domain response

% fpoints: are the frequency points
%out is the output node name 
out_NodeNumber = getNodeNumber({out}) ;  % node number associated with each node 


