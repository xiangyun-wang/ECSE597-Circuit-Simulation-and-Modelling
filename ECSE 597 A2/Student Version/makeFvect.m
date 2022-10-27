function Fvect = makeFvect(X)
% this function creates a nonlinear vector in the MNA matrices.
% X is the MNa vector containing the node voltages/currents/flux/charge

global elementList

Fvect  = sparse(elementList.n,1);

% add diodes using this
for I=1:elementList.Diodes.numElements
    nodes = elementList.Diodes.nodeNumbers(I,:);
    % nodes(1) is the positive node of the diode
    % node(2) is the negative node of the diode.
    
    n1 = nodes(1);
    n2 = nodes(2);
   
     % get other parameters
     Vt = elementList.Diodes.Vt(I);  % thermal voltage of the I^th Diode 
     Is = elementList.Diodes.Is(I);       % sturation current for the I^th Diode
     
     
     % Votage at positive node of the diode :
          % Votage at negative node of the diode :

     
     if (n1 ~= 0 && n2 ~= 0)
        Vp = X(n1);
        Vn= X(n2);
        Id = Is * (exp((Vp-Vn)/Vt)-1);
        Fvect(n1) = Fvect(n1) + Id;
        Fvect(n2) = Fvect(n2) - Id;
     elseif (n1 == 0)
        Vp = 0;
        Vn= X(n2);
        Id = Is * (exp((Vp-Vn)/Vt)-1);
        Fvect(n2) = Fvect(n2) - Id;
     else
        Vp = X(n1);
        Vn= 0;
        Id = Is * (exp((Vp-Vn)/Vt)-1);
        Fvect(n1) = Fvect(n1) + Id;
     end
     
end



% add BJts using this
for I=1:elementList.BJTs.numElements
   
     
     %get Nodes Numbers
     cNode = elementList.BJTs.nodeNumbers(I,1);  % collector node.
     bNode = elementList.BJTs.nodeNumbers(I,2);    % base node.
     eNode = elementList.BJTs.nodeNumbers(I,3);    % emitter node
     


     % get other parameters
     Vt = elementList.BJTs.Vt(I);  % thermal voltage of the I^th BJT
     Is = elementList.BJTs.Is(I);       % sturation current for the I^th BJT
     alphaR = elementList.BJTs.alphaR(I);
     alphaF =  elementList.BJTs.alphaF(I);
     
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
     If = Is * (exp((Vb - Ve)/Vt)-1);
     Ir = Is * (exp((Vb - Vc)/Vt)-1);
         % need to change
     Ie = (-1)*If + alphaR * Ir;
     
     Ic = (-1)*Ir + alphaF * If;
     Ib = (-1) * (Ie + Ic);

     if cNode ~= 0
        Fvect(cNode) = Fvect(cNode) + Ic;
     end

     if bNode ~= 0
         Fvect(bNode) = Fvect(bNode) + Ib;
     end

     if eNode ~= 0
         Fvect(eNode) = Fvect(eNode) + Ie;
     end
    
     
end