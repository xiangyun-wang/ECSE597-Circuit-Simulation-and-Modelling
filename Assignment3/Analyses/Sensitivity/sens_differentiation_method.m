function [D,S] = sens_differentiation_method(fpoints,eleNames,outNode)
% This function uses the DIFFERENTIATION method to compute the sensitivity of the
% output node with respect to all the parameters.
%Inputs: 1. fpoints: contains the frequency points at which the sensitivity is
% is required.
% 2. eleNames: is a cell array contains the names of the elements.
% 3. outNode: is the node for which the sensitivity is required.
%Output: 1.D: is a matrix. It should contain the ABSOLUTE sensitivity of the
% outNode at all fpoints for all elements.
% One way to fill store senstivity in D is to add sensitivity of
% a given element in one column of D for all fpoints.
% In this case if there are F number of frequency points and
% P number of elements in eleNames, then the size of matrix D
% will be F x P.
% 2. S: is matrix. It should contain the RELATIVE sensitivity of
% outNode for all the elements in eleNames. It can be filled
% similar to matrix D.

%calculate frequency anaysis at all frequency at outNode -> X

flag = 0
ori_Gmat = makeGmatrix;
ori_Cmat = makeCmatrix;
for element = eleNames
    delta_Gmat = zeros(size(ori_Gmat));
    delta_Cmat = zeros(size(ori_Cmat));
    flag = 0;
    for I=1:elementList.Resistors.numElements
    
        % access nodes Numbers of the Resistor
        %nodes of a I^{th} element are located in Row I of the nodeNumbers
        %field
        name = elementList.Resistors.Name(I);
        if strcmp(name,element) 
            nodes = elementList.Resistors.nodeNumbers(I,:);
        
            % get the conductance for the resisitor
            % resistance is stored in the field named value
            if(nodes(1)~=0) && (nodes(2)~=0)
                delta_Gmat(nodes(1),nodes(1)) = 1;
                delta_Gmat(nodes(1),nodes(2)) = -1;
                delta_Gmat(nodes(2),nodes(1)) = -1;
                delta_Gmat(nodes(2),nodes(2)) = 1;
            elseif (nodes(1)==0) && (nodes(2)~=0)
            
                delta_Gmat(nodes(2),nodes(2)) = 1;
            
            elseif (nodes(1)~=0) && (nodes(2)==0)
                delta_Gmat(nodes(1),nodes(1)) = 1;
            end
            flag = 1;
            break;
        end 
        
    end
    if flag == 0
        for I=1:elementList.Capacitors.numElements
        
            % access nodes Numbers of the Resistor
            %nodes of a I^{th} element are located in Row I of the nodeNumbers
            %field
            name = elementList.Capacitors.Name(I);
            if strcmp(name,element) 
                nodes = elementList.Capacitors.nodeNumbers(I,:);
            
                % get the conductance for the resisitor
                % resistance is stored in the field named value
                c= elementList.Capacitors.value(I);
                c_delta= elementList.Capacitors.value(I)*1.01;
                if(nodes(1)~=0) && (nodes(2)~=0)
                    delta_Cmat(nodes(1),nodes(1)) = 1;
                    delta_Cmat(nodes(1),nodes(2)) = -1;
                    delta_Cmat(nodes(2),nodes(1)) = -1;
                    delta_Cmat(nodes(2),nodes(2)) = 1;
                elseif (nodes(1)==0) && (nodes(2)~=0)
                    
                    delta_Cmat(nodes(2),nodes(2)) = 1;
                    
                elseif (nodes(1)~=0) && (nodes(2)==0)
                    delta_Cmat(nodes(1),nodes(1)) = 1;
                end
                break;
            end
        end
    end

    % now we have the changed delta_G and delta_C -> dA/dlamda = delta_G +
    % jw*delta_C
    % loop over all frequency, select outnode

end



end

