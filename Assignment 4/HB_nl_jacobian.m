function J = HB_nl_jacobian(Xb,H)

%  this function takes the time domain vector Xs as input and returns
%  Jacobian J in FREQUENCY domain.

% Inputs: 1.  Xs is the Newton-Raphson guess vector in time domain
%        2. H is the number of harmonics

% Output: J is the jacobain of the nonlinear vector in the frequency dommain.


global elementList

n = elementList.n;
Nh = 2*H+1; % number of fourier coefficients.
G = makeGmatrix;
[row, column] = size(G);
gamma_block = makeGamma(H);
for I=1:row
    gamma((I-1)*Nh+1:(I)*Nh,(I-1)*Nh+1:(I)*Nh) = gamma_block;
end 

J = sparse(elementList.n*Nh,elementList.n*Nh);
X_s = gamma * Xb;
%% Fill in the J for Diodes
for I=1:elementList.Diodes.numElements
    nodes = elementList.Diodes.nodeNumbers(I,:);
    % nodes(1) is the positive node of the diode
    % node(2) is the negative node of the diode.
    
     % get other parameters
     Vt = elementList.Diodes.Vt(I);  % thermal voltage of the I^th Diode  element 
     Is = elementList.Diodes.Is(I);       % sturation current for the I^th Diode element
    
      % Votage at positive node of the diode : 
     if nodes(1) ~= 0
        Vp = X_s((nodes(1)-1)*Nh+1:nodes(1)*Nh);
     else
         Vp = zeros(Nh);
     end
     % Votage at negative node of the diode :  
     if nodes(2) ~= 0
        Vn= X_s((nodes(2)-1)*Nh+1:nodes(2)*Nh);
     else
         Vn = zeros(Nh);
     end
        
     % add your contribution to Fvect here
     for K = 1:Nh
        block11(K,K) = Is / Vt * exp((Vp(K)-Vn(K))/Vt);
        block12(K,K) = (-1) * Is / Vt * exp((Vp(K)-Vn(K))/Vt);
        block21(K,K) = (-1) * Is / Vt * exp((Vp(K)-Vn(K))/Vt);
        block22(K,K) = Is / Vt * exp((Vp(K)-Vn(K))/Vt);
     end

     if nodes(1) ~= 0 && nodes(2) ~= 0 
        J((nodes(1)-1)*Nh+1:nodes(1)*Nh, (nodes(1)-1)*Nh+1:nodes(1)*Nh) = block11;
        J((nodes(1)-1)*Nh+1:nodes(1)*Nh, (nodes(2)-1)*Nh+1:nodes(2)*Nh) = block12;
        J((nodes(2)-1)*Nh+1:nodes(2)*Nh, (nodes(1)-1)*Nh+1:nodes(1)*Nh) = block21;
        J((nodes(2)-1)*Nh+1:nodes(2)*Nh, (nodes(2)-1)*Nh+1:nodes(2)*Nh) = block22;
     elseif nodes(1) == 0 
        J((nodes(2)-1)*Nh+1:nodes(2)*Nh, (nodes(2)-1)*Nh+1:nodes(2)*Nh) = block22;
     else
        J((nodes(1)-1)*Nh+1:nodes(1)*Nh, (nodes(1)-1)*Nh+1:nodes(1)*Nh) = block11;
     end
    
end

J = gamma\J*gamma;