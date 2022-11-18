function [D,S] = sens_perturbation_method(fpoints,eleNames,outNode)
% This function uses DIFFERENCE method to compute the sensitivity of the 
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

delta = 1e-7;


%%
for I=1:length(eleNames)
    eleName = eleNames{I};
    switch upper(eleName(1)) %check the first letter of the element name
        
        case 'R' % The name of resistors start with letter R
            
            % For the given Resistor we get to know it's nodes and it's value
            % This can be done in 2 steps.
            
            % 1. Get the Index of the element.
            eleIdx = elementList.Resistors.containerMap(eleName);
            % get the node names for verification with netlist.
            NodeNames = elementList.Resistors.NodeNames{eleIdx};
            
            %2. Now obtain the node numbers and resitance for this resistor.
            nodes = elementList.Resistors.nodeNumbers(eleIdx,:);
            val = elementList.Resistors.value(eleIdx);
            
            % write your solution here... Feel free to modify the function
            % in any way.
            
        case 'C' % The name of capcitors start with letter C

            eleIdx = elementList.Capacitors.containerMap(eleName);
            % get the node names for verification with netlist.
            NodeNames = elementList.Capacitors.NodeNames{eleIdx};
            
    end
end




end