function [u,R] = solveSys(vL,vR,uR,KG,Fext,method)
%--------------------------------------------------------------------------
% The function takes as inputs:
%   - vL      Free degree of freedom vector
%   - vR      Prescribed degree of freedom vector
%   - uR      Prescribed displacement vector
%   - KG      Global stiffness matrix [n_dof x n_dof]
%              KG(I,J) - Term in (I,J) position of global stiffness matrix
%   - Fext    Global force vector [n_dof x 1]
%              Fext(I) - Total external force acting on DOF I
%--------------------------------------------------------------------------
% It must provide as output:
%   - u       Global displacement vector [n_dof x 1]
%              u(I) - Total displacement on global DOF I
%   - R       Global reactions vector [n_dof x 1]
%              R(I) - Total reaction acting on global DOF I
%--------------------------------------------------------------------------

K_LL=KG(vL,vL);
K_LR=KG(vL,vR);
K_RL=KG(vR,vL);
K_RR=KG(vR,vR);
Fext_L=Fext(vL,1);
Fext_R=Fext(vR,1);

LHS = K_LL;
RHS = Fext_L-K_LR*uR;

class = Solver(LHS,RHS,method);
uL = class.solve();

R=K_RR*uR+K_RL*uL-Fext_R;

u(vL,1)=uL;
u(vR,1)=uR;

%% UL UNIT TESTING

% unit_testing = matfile('unit_testing.mat','Writable',true);
%  
% unit_testing.uL = uL;

unit_testing = load('unit_testing.mat');

error_uL = unit_testing.uL - uL;

[numRows,numCols] = size(error_uL);

for i = 1 : numRows

    for j = 1 : numCols

        if error_uL(i,j) == 0
 
        else
            disp("Error in global displacement vector assembly (u) row "+ i +" column "+ j);
        end
    end
end