function [u,R] = solveSys(vL,vR,uR,KG,Fext)
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

uL=inv(K_LL)*(Fext_L-K_LR*uR);

R=K_RR*uR+K_RL*uL-Fext_R;

u(vL,1)=uL;
u(vR,1)=uR;


end