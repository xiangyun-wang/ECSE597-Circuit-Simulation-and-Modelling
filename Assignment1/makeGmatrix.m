function Gmat = makeGmatrix()

global elementList nodeMap
elementList.n = elementList.numNodes; % MNA size
Gmat = sparse(elementList.n,elementList.n);

% add stamp for resistors

for I=1:elementList.Resistors.numElements
    
    % access nodes Numbers of the Resistor
    %nodes of a I^{th} element are located in Row I of the nodeNumbers
    %field
    
    nodes = elementList.Resistors.nodeNumbers(I,:);
    
    
    % get the conductance for the resisitor
    % resistance is stored in the field named value
    g = 1/( elementList.Resistors.value(I));
    
    if(nodes(1)~=0) && (nodes(2)~=0)
        Gmat(nodes(1),nodes(1)) = Gmat(nodes(1),nodes(1))  + g;
        Gmat(nodes(1),nodes(2)) = Gmat(nodes(1),nodes(2)) - g;
        Gmat(nodes(2),nodes(1)) = Gmat(nodes(2),nodes(1)) - g;
        Gmat(nodes(2),nodes(2)) = Gmat(nodes(2),nodes(2)) + g;
    elseif (nodes(1)==0) && (nodes(2)~=0)
        
        Gmat(nodes(2),nodes(2)) = Gmat(nodes(2),nodes(2)) + g;
        
    elseif (nodes(1)~=0) && (nodes(2)==0)
        Gmat(nodes(1),nodes(1)) = Gmat(nodes(1),nodes(1))  + g;
    end
    
end

% for  DC voltage sources

for I=1:elementList.DC_VolSources.numElements
    % access nodes Numbers of the Resistor
    %nodes of a I^{th} element are located in Row I of the nodeNumbers
    %field
    
    nodes = elementList.DC_VolSources.nodeNumbers(I,:);
    
    % For voltage sources we need to add an extra row and a column 
    nX= elementList.n+1;  % extra node 
    elementList.n = elementList.n+1;  % update the numNode
    
    % store the extra node as you will need this in in filling Bvector
      % to do this we use the field currIndex in DC_volSources
     elementList.DC_VolSources.currIndex(I) = nX;
    
     Gmat(nX,nX)=0;   %  update the size of Gmat
     
    if(nodes(1)~=0)
        Gmat(nX,nodes(1)) = Gmat(nX,nodes(1))  + 1;
        Gmat(nodes(1),nX) = Gmat(nodes(1),nX) +1;

    end
    if(nodes(2)~=0)
        Gmat(nX,nodes(2)) = Gmat(nX,nodes(2))  - 1;
        Gmat(nodes(2),nX) = Gmat(nodes(2),nX) - 1;
    end 

    
end 


% add stamps for other elements here...

% for inductors 
for I=1:elementList.Inductors.numElements
    nodes = elementList.Inductors.nodeNumbers(I,:);
    
    % For voltage sources we need to add an extra row and a column 
    nX= elementList.n+1;  % extra node 
    elementList.n = elementList.n+1;  % update the numNode
    
    % store the extra node as you will need this in in filling Bvector
      % to do this we use the field currIndex in DC_volSources
     elementList.Inductors.currIndex(I) = nX;
    
     Gmat(nX,nX)=0;   %  update the size of Gmat
     
    if(nodes(1)~=0)
        Gmat(nX,nodes(1)) = Gmat(nX,nodes(1))  + 1;
        Gmat(nodes(1),nX) = Gmat(nodes(1),nX) +1;  

    end
    if(nodes(2)~=0)
        Gmat(nX,nodes(2)) = Gmat(nX,nodes(2))  - 1;
        Gmat(nodes(2),nX) = Gmat(nodes(2),nX) - 1;
    end 
end

% for voltage controlled current source
for I=1:elementList.VCCS.numElements
    nodes = elementList.VCCS.nodeNumbers(I,:);
    
    % get the conductance for the resisitor
    % resistance is stored in the field named value
    gm = elementList.VCCS.value(I);
    
%     if(nodes(1)~=0) && (nodes(2)~=0)
%         Gmat(nodes(1),nodes(3)) = Gmat(nodes(1),nodes(3))  + gm;
%         Gmat(nodes(1),nodes(4)) = Gmat(nodes(1),nodes(4)) - gm;
%         Gmat(nodes(2),nodes(3)) = Gmat(nodes(2),nodes(3)) - gm;
%         Gmat(nodes(2),nodes(4)) = Gmat(nodes(2),nodes(4)) + gm;
%     elseif (nodes(1)==0) && (nodes(2)~=0)
%         
%         Gmat(nodes(2),nodes(3)) = Gmat(nodes(2),nodes(3)) - gm;
%         Gmat(nodes(2),nodes(4)) = Gmat(nodes(2),nodes(4)) + gm;
%         
%     elseif (nodes(1)~=0) && (nodes(2)==0)
%         Gmat(nodes(1),nodes(3)) = Gmat(nodes(1),nodes(3))  + gm;
%         Gmat(nodes(1),nodes(4)) = Gmat(nodes(1),nodes(4)) - gm;
%     end
     if(nodes(1)~=0) 
         Gmat(nodes(1),nodes(3)) = Gmat(nodes(1),nodes(3))  + gm;
         Gmat(nodes(1),nodes(4)) = Gmat(nodes(1),nodes(4)) - gm;
     elseif (nodes(2)~=0)
         Gmat(nodes(2),nodes(3)) = Gmat(nodes(2),nodes(3)) - gm;
         Gmat(nodes(2),nodes(4)) = Gmat(nodes(2),nodes(4)) + gm;
     end
end 

% for voltage controlled voltage source
for I=1:elementList.VCVS.numElements
    % access nodes Numbers of the Resistor
    %nodes of a I^{th} element are located in Row I of the nodeNumbers
    %field
    A = elementList.VCVS.value(I);
    nodes = elementList.VCVS.nodeNumbers(I,:);
    
    % For voltage sources we need to add an extra row and a column 
    nX= elementList.n+1;  % extra node 
    elementList.n = elementList.n+1;  % update the numNode
    
    % store the extra node as you will need this in in filling Bvector
      % to do this we use the field currIndex in DC_volSources
     elementList.VCVS.currIndex(I) = nX;
    
     Gmat(nX,nX)=0;   %  update the size of Gmat
     
    if(nodes(3)~=0)
        Gmat(nodes(3),nX) = Gmat(nodes(3),nX) +1;
        Gmat(nX,nodes(3)) = Gmat(nX,nodes(3))  + 1;

    end
    if(nodes(4)~=0)
        Gmat(nX,nodes(4)) = Gmat(nX,nodes(4))  - 1;
        Gmat(nodes(4),nX) = Gmat(nodes(4),nX) - 1;
    end 
    if (nodes(1)~=0)
        Gmat(nX,nodes(1)) = Gmat(nX,nodes(1)) - A;
    end
    if (nodes(2)~=0)
        Gmat(nX,nodes(2)) = Gmat(nX,nodes(2)) + A;
    end
end 

% for current controlled current source
for I=1:elementList.CCCS.numElements
    % access nodes Numbers of the Resistor
    %nodes of a I^{th} element are located in Row I of the nodeNumbers
    %field
    A = elementList.CCCS.value(I);
    nodes = elementList.CCCS.nodeNumbers(I,:);
    
    % For voltage sources we need to add an extra row and a column 
    nX= elementList.n+1;  % extra node 
    elementList.n = elementList.n+1;  % update the numNode
    
    % store the extra node as you will need this in in filling Bvector
      % to do this we use the field currIndex in DC_volSources
     elementList.CCCS.currIndex(I) = nX;
    
     Gmat(nX,nX)=0;   %  update the size of Gmat
     
    if(nodes(3)~=0)
        Gmat(nodes(3),nX) = Gmat(nodes(3),nX) + A;
    end
    if(nodes(4)~=0)
        Gmat(nodes(4),nX) = Gmat(nodes(2),nX) - A;
    end 
    if (nodes(1)~=0)
        Gmat(nX,nodes(1)) = Gmat(nX,nodes(1)) +1;
        Gmat(nodes(1),nX) = Gmat(nodes(1),nX) +1;
    end
    if (nodes(2)~=0)
        Gmat(nX,nodes(2)) = Gmat(nX,nodes(2)) - 1;
        Gmat(nodes(2),nX) = Gmat(nodes(2),nX) - 1;
    end
end 
% ideal opamp
for I=1:elementList.OpAmps.numElements
    % access nodes Numbers of the Resistor
    %nodes of a I^{th} element are located in Row I of the nodeNumbers
    %field
    nodes = elementList.OpAmps.nodeNumbers(I,:);
    
    % For voltage sources we need to add an extra row and a column 
    nX= elementList.n+1;  % extra node 
    elementList.n = elementList.n+1;  % update the numNode
    
    % store the extra node as you will need this in in filling Bvector
      % to do this we use the field currIndex in DC_volSources
     elementList.OpAmps.currIndex(I) = nX;
    
     Gmat(nX,nX)=0;   %  update the size of Gmat
     
    if(nodes(3)~=0)
        Gmat(nodes(3),nX) = Gmat(nodes(3),nX) +1;
    end
    if(nodes(4)~=0)
        Gmat(nodes(4),nX) = Gmat(nodes(4),nX) - 1;
    end 
    if (nodes(1)~=0)
        Gmat(nX,nodes(1)) = Gmat(nX,nodes(1)) - 1;
    end
    if (nodes(2)~=0)
        Gmat(nX,nodes(2)) = Gmat(nX,nodes(2)) + 1;
    end
end 
% mutual inductance