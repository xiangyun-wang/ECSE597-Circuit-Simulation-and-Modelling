function Bvec = makeBvector()

global elementList 

numNodes = elementList.numNodes;
Bvec = sparse(numNodes,1);


% add stamps here...
for I=1:elementList.DC_VolSources.numElements
    % acess the current  index 
    e = elementList.DC_VolSources.value(I);
    Bvec(elementList.DC_VolSources.currIndex(I)) = E;
end 

% for current source
for I=1:elementList.DC_CurSources.numElements
    nodes = elementList.DC_CurSources.nodeNumbers(I,:);
    i = ( elementList.DC_CurSources.value(I));
    if nodes(1) ~= 0
        Bvec(nodes(1)) = (-1) * i;
    end
    if node(2) ~= 0
        Bvec(nodes(1)) = i;
    end
end 
