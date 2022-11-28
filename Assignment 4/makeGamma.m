function gamma =  makeGamma(H)
% This function takes numner of Harmonics as ouput and returns gamma  as
% described in the lecture notes/slides.

% Input: H is the number of harmonics
% gamma: matrix
G= makeGmatrix;
Nh = 2*H+1; % number of fourier coefficients
[row, column] = size(G);

% block of gamma
gamma_block = zeros([Nh,Nh]);
gamma_block(:,1) = ones([Nh,1]);

for I = 1:Nh
    for J = 1:H
        gamma_block(I,J*2) = cos(J*(I-1)*(2*pi)/Nh);
        gamma_block(I,J*2+1) = sin(J*(I-1)*(2*pi)/Nh);
    end
end

%for I=1:row
 %   gamma((I-1)*Nh+1:(I)*Nh,(I-1)*Nh+1:(I)*Nh) = gamma_block;
%end 

gamma = gamma_block;