function [D,S] = sens_differentiation_method(fpoints,eleNames,out)
global elementList
flag = 0;
ori_Gmat = makeGmatrix;
ori_Cmat = makeCmatrix;
f_r_v = f_solve_vector(fpoints, ori_Gmat, ori_Cmat);
out_NodeNumber = getNodeNumber(out) ; 
lamda = 0;
for m = 1:length(eleNames)
    delta_Gmat = zeros(size(ori_Gmat));
    delta_Cmat = zeros(size(ori_Cmat));
    element = eleNames(m);
    flag = 0;
    for I=1:elementList.Resistors.numElements
        name = elementList.Resistors.Name(I);
        lamda = 1/elementList.Resistors.value(I);
        if strcmp(name,element) 
            nodes = elementList.Resistors.nodeNumbers(I,:);
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
            name = elementList.Capacitors.Name(I);
            lamda = elementList.Capacitors.value(I);
            if strcmp(name,element) 
                nodes = elementList.Capacitors.nodeNumbers(I,:);
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

    for I = 1:length(fpoints)
        A = (ori_Gmat+2*pi*fpoints(I)*1i*ori_Cmat);
        delta_abs = A\((-1)*(delta_Gmat+2*pi*fpoints(I)*1i*delta_Cmat)*transpose(f_r_v(I,:)));
        D(I,m) = delta_abs(out_NodeNumber);
        S(I,m) = D(I,m)*(lamda/f_r_v(I,out_NodeNumber));
    end
end

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





end