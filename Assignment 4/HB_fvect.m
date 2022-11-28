function Fvect_bar = HB_fvect(X_bar,H)
% this function creates a nonlinear vector in the MNA matrices.
% X is the MNa vector containing the node voltages/currents/flux/charge

global elementList
size(X_bar)
Fvect_bar  = zeros(size(X_bar));
Nh = 2*H + 1;
G= makeGmatrix;
[row, column] = size(G);
gamma_block = makeGamma(H);
for I=1:row
    gamma((I-1)*Nh+1:(I)*Nh,(I-1)*Nh+1:(I)*Nh) = gamma_block;
end 

X_s = gamma * X_bar;

% add diodes using this
for I=1:elementList.Diodes.numElements
    nodes = elementList.Diodes.nodeNumbers(I,:);
    % nodes(1) is the positive node of the diode
    % node(2) is the negative node of the diode.
    
    n1 = nodes(I,1);
    n2 = nodes(I,2);
   
     % get other parameters
     Vt = elementList.Diodes.Vt(I);  % thermal voltage of the I^th Diode 
     Is = elementList.Diodes.Is(I);       % sturation current for the I^th Diode
     
    for J = 1:Nh
        Vd = X_s((n1-1)*Nh+J) - X_s((n2-1)*Nh+J);
        Fv1(J,1) = Is*( exp(Vd/Vt) - 1);
        Fv2(J,1) = -Is*( exp( Vd/Vt) - 1);
    end

    if(nodes(1)~=0 && nodes(2)~=0)        
        Fvect_bar((n1-1)*Nh+1:n1*Nh,1) = Fv1 ;
        Fvect_bar((n2-1)*Nh+1:n2*Nh,1) = Fv2 ;
    elseif (nodes(1)==0 && nodes(2)~=0)
        Fvect_bar((n2-1)*Nh+1:n2*Nh,1) = Fv2 ;
        
    elseif(nodes(1)~=0 && nodes(2)==0)
        Fvect_bar((n1-1)*Nh+1:n1*Nh,1) = Fv1 ;
    end
    
end

Fvect_bar = gamma\Fvect_bar;