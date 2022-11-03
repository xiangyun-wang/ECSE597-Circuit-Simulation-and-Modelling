function [Bdc, Bac] = makeBvector()
% This function adds the contribution of input sources in the Bvector

% Bdc is the MNA RHS vector containing the contribution of  DC sources 
% Bac is the MNA RHS vector containing the contribution of  AC sources 
global elementList 

 
Bdc = sparse(elementList.n,1);
Bac = sparse(elementList.n,1);

% add stamps here...
for I=1:elementList.DC_VolSources.numElements
    % acess the current  index 
    nX = elementList.DC_VolSources.currIndex(I);
    Bdc(nX,1) =  elementList.DC_VolSources.VAL_DC(I);
end 

for I=1:elementList.DC_CurSources.numElements
    nodes = elementList.DC_CurSources.nodeNumbers(I,:);
    i = ( elementList.DC_CurSources.value(I));
    if nodes(1) ~= 0
        Bdc(nodes(1),1) = (-1) * i;
    end
    if node(2) ~= 0
        Bdc(nodes(2),1) = i;
    end
end 

% add stamps here...
for I=1:elementList.AC_VolSources.numElements
    % acess the current  index 
    nX = elementList.AC_VolSources.curIdx(I);
    %nX = elementList.AC_VolSources.curIdx(I);
    Bac(nX,1) =  elementList.AC_VolSources.AMPLITUDE(I);
end 

 for I=1:elementList.AC_CurSources.numElements
     nodes = elementList.AC_CurSources.nodeNumbers(I,:);
     i = elementList.AC_CurSources.AMPLITUDE(I);
     if nodes(1) ~= 0
         Bac(nodes(1),1) = (-1) * i;
     end
    if node(2) ~= 0
         Bac(nodes(2),1) = i;
     end
end 