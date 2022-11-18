function [D,S] = sens_differentiation_method(fpoints,eleNames,out)
% This function uses DIFFERENTIATION method to compute the sensitivity of the 
% output node with respect to all the parameters.
%Inputs: 1. fpoints: contains the frequency points at which the sensitivity is
%                 is required.
%        2. eleNames: is a cell array contains the names of the elements.
%        3. outNode: is the node for which the sensitivity is required.

%Output:  1.D:  is a matrix.  It should contain the ABSOLUTE sensitivity of the
%              outNode at all fpoints for all elements.
%              One way to fill store senstivity in  D is to  add sensitivity of 
%              a given element in one column of D for all fpoints.
%              In this case if there are F number of frequency points and 
%              P number of elements in eleNames, then the size of matrix D
%              will be FxP.
%
%         2. S: is  matrix. It should contain the RELATIVE sensitivity of 
%               outNode for all the elements in eleNames. It can be filled
%               similar to matrix D.
%
%
%Note: There are multiple ways to add the code for computing  sensitivity..
%      The function stub provided is just an example. You can modify the 
%      in function in any fashion. Even you can split this function in to
%      multiple functions.
%--------------------------------------------------------------------------
global elementList


%%
out_NodeNumber = getNodeNumber(out) ;





end