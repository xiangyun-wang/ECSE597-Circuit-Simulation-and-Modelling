function [D,S] = sens_perturbation_method(fpoints,eleNames,outNode)
% find elements
global elementList
flag = 0
ori_Gmat = makeGmatrix;
ori_Cmat = makeCmatrix;
out_NodeNumber = getNodeNumber(outNode);
ori_r = fsolve( fpoints ,outNode, ori_Gmat, ori_Cmat);
for m = 1:length(eleNames)
    element = eleNames(m);
    Gmat = ori_Gmat;
    Cmat = ori_Cmat;
    flag = 0;
    for I=1:elementList.Resistors.numElements
        name = elementList.Resistors.Name(I);
        if strcmp(name,element) 
            nodes = elementList.Resistors.nodeNumbers(I,:);
            g = 1/( elementList.Resistors.value(I));
            g_delta = (1.0000001/( elementList.Resistors.value(I)));
            delta_lamda = 0.0000001/( elementList.Resistors.value(I));
            lamda = g;
            if(nodes(1)~=0) && (nodes(2)~=0)
                Gmat(nodes(1),nodes(1)) = Gmat(nodes(1),nodes(1))  - g + g_delta;
                Gmat(nodes(1),nodes(2)) = Gmat(nodes(1),nodes(2)) + g - g_delta;
                Gmat(nodes(2),nodes(1)) = Gmat(nodes(2),nodes(1)) + g - g_delta;
                Gmat(nodes(2),nodes(2)) = Gmat(nodes(2),nodes(2)) - g + g_delta;
            elseif (nodes(1)==0) && (nodes(2)~=0)
            
                Gmat(nodes(2),nodes(2)) = Gmat(nodes(2),nodes(2)) - g + g_delta;
            
            elseif (nodes(1)~=0) && (nodes(2)==0)
                Gmat(nodes(1),nodes(1)) = Gmat(nodes(1),nodes(1))  - g + g_delta;
            end
            flag = 1;
            break;
        end 
        
    end
    if flag == 0
        for I=1:elementList.Capacitors.numElements
            name = elementList.Capacitors.Name(I);
            if strcmp(name,element) 
                nodes = elementList.Capacitors.nodeNumbers(I,:);
                c= elementList.Capacitors.value(I);
                c_delta= elementList.Capacitors.value(I)*1.0000001;
                delta_lamda = elementList.Capacitors.value(I)*0.0000001;
                lamda = c;
                if(nodes(1)~=0) && (nodes(2)~=0)
                    Cmat(nodes(1),nodes(1)) = Cmat(nodes(1),nodes(1))  - c + c_delta;
                    Cmat(nodes(1),nodes(2)) = Cmat(nodes(1),nodes(2)) + c - c_delta;
                    Cmat(nodes(2),nodes(1)) = Cmat(nodes(2),nodes(1)) + c - c_delta;
                    Cmat(nodes(2),nodes(2)) = Cmat(nodes(2),nodes(2)) - c + c_delta;
                elseif (nodes(1)==0) && (nodes(2)~=0)
                    
                    Cmat(nodes(2),nodes(2)) = Cmat(nodes(2),nodes(2)) - c + c_delta;
                    
                elseif (nodes(1)~=0) && (nodes(2)==0)
                    Cmat(nodes(1),nodes(1)) = Cmat(nodes(1),nodes(1))  - c + c_delta;
                end
                break;
            end
        end
    end

    % now we have the changed G and C

    delta_r = fsolve( fpoints ,outNode, Gmat, Cmat) - ori_r;
    D(:,m) = delta_r/delta_lamda;
    for I = 1:length(fpoints)
        S(I,m) = D(I,m)*(lamda/ori_r(I));
    end
end

end

% This function uses DIFFERENCE method to compute the sensitivity of the
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
% will be FxP.
% 2. S: is matrix. It should contain the RELATIVE sensitivity of
% outNode for all the elements in eleNames. It can be filled
% similar to matrix D.

% delta_something/something = 0.01

