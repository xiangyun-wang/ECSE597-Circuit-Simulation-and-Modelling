function J = make_nlJacobian(X)
% Input: X is the MNA solution vector. It contains the 
% node voltages and currents etc.

global elementList

J  = sparse(elementList.n,elementList.n);

% add diodes using this 
for I=1:elementList.Diodes.numElements
    nodes = elementList.Diodes.nodeNumbers(I,:);
    % nodes(1) is the positive node of the diode
    % node(2) is the negative node of the diode.
    
     % get other parameters
     Vt = elementList.Diodes.Vt(I);  % thermal voltage of the I^th Diode  element 
     Is = elementList.Diodes.Is(I);       % sturation current for the I^th Diode element
    
      % Votage at positive node of the diode : 
     if nodes(1) ~= 0
        Vp = X(nodes(1));
     else
         Vp = 0;
     end
     % Votage at negative node of the diode :  
     if nodes(2) ~= 0
        Vn= X(nodes(2));
     else
         Vn = 0;
     end
        
     % add your contribution to Fvect here
     if nodes(1) ~= 0 && nodes(2) ~= 0 
        J(nodes(1), nodes(1)) = Is / Vt * exp((Vp-Vn)/Vt);
        J(nodes(1), nodes(2)) = (-1) * Is / Vt * exp((Vp-Vn)/Vt);
        J(nodes(2), nodes(1)) = (-1) * Is / Vt * exp((Vp-Vn)/Vt);
        J(nodes(2), nodes(2)) = Is / Vt * exp((Vp-Vn)/Vt);
     elseif nodes(1) == 0 
        J(nodes(2), nodes(2)) = Is / Vt * exp((Vp-Vn)/Vt);
     else
        J(nodes(1), nodes(1)) = Is / Vt * exp((Vp-Vn)/Vt);
     end
    
end

% add BJts using this 
for I=1:elementList.BJTs.numElements
    
     
      %get Nodes Numbers
     cNode = elementList.BJTs.nodeNumbers(I,1);    % collector node.
     bNode = elementList.BJTs.nodeNumbers(I,2);    % base node.
     eNode = elementList.BJTs.nodeNumbers(I,3);    % emitter node
     
     % get other parameters of the BJTs 
     Vt = elementList.BJTs.Vt(I);  % thermal voltage of the I^th BJT
     Is = elementList.BJTs.Is(I);       % sturation current for the I^th BJT
     alphaR = elementList.BJTs.alphaR(I);
     alphaF =  elementList.BJTs.alphaF(I);
     
 
    % add your contribution to Fvect here

    if cNode == 0
        Vc = 0;
     else
        Vc = X(cNode);
     end

     if bNode == 0
        Vb = 0;
     else
        Vb = X(bNode);
     end

     if eNode == 0
        Ve = 0;
     else
        Ve = X(eNode);
     end

     J(cNode,bNode) = 1/Vt * exp((Vb-Ve)/Vt);
     J(cNode,eNode) = (-1)/Vt * exp((Vb-Ve)/Vt);
     J(bNode,bNode) = (1-alphaR)/alphaR * (1/Vt) * exp((Vb-Ve)/Vt);
     J(bNode,eNode) = (-1)*(1-alphaR)/alphaR * (1/Vt) * exp((Vb-Ve)/Vt);
     J(eNode,bNode) = (-1)/alphaR * (1/Vt) * exp((Vb-Ve)/Vt);
     J(eNode,eNode) = (1)/alphaR * (1/Vt) * exp((Vb-Ve)/Vt);
    
     if cNode == 0
        J(cNode,bNode) = 0;
        J(cNode,eNode) = 0;
     end

     if bNode == 0
        J(bNode,bNode) = 0;
        J(bNode,eNode) = 0;
        J(cNode,bNode) = 0;
        J(eNode,bNode) = 0;
     end

     if eNode == 0
        J(eNode,bNode) = 0;
        J(eNode,eNode) = 0;
        J(cNode,eNode) = 0;
        J(bNode,eNode) = 0;
     end

end 

