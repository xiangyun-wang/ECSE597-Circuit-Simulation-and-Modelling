function [D,S] = sens_adjoint_method(fpoints,eleNames,outNode)
% This function uses the ADJOINT method to compute the sensitivity of the
% output node with respect to all the parameters.
%Inputs: 1. fpoints: contains the frequency points at which the sensitivity is
% is required.
% 2. eleNames: is a cell array contains the names of the elements.
% 3. outNode: is the node for which the sensitivity is required.
%Output: 1.D: is a matrix. It should contain the ABSOLUTE sensitivity of the
% outNode at all fpoints for all elements.
% One way to fill store sensitivity in D is to add sensitivity of
% a given element in one column of D for all fpoints.
% In this case if there are F number of frequency points and
% P number of elements in eleNames, then the size of matrix D
% will be F x P.
% 2. S: is matrix. It should contain the RELATIVE sensitivity of
% outNode for all the elements in eleNames. It can be filled
% similar to matrix D.



end

