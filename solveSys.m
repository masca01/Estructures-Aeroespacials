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

classdef solveSys < mainA02

    properties (Access = public)
        LHS
        RHS
        uL
    end

    methods (Access = public)


        function [u,R] = calc(obj,vL,vR,uR,KG,Fext)

            obj.vL = vL;
            obj.vR = vR;
            obj.uR = uR;
            obj.KG = KG;
            obj.Fext = Fext;

            K_LL = obj.KG(obj.vL,obj.vL);
            K_LR = obj.KG(obj.vL,obj.vR);
            K_RL = obj.KG(obj.vR,obj.vL);
            K_RR = obj.KG(obj.vR,obj.vR);
            Fext_L = obj.Fext(obj.vL,1);
            Fext_R = obj.Fext(obj.vR,1);

            obj.LHS = K_LL;
            obj.RHS = Fext_L-K_LR*obj.uR;

            class_solver = Solver();
            obj.uL = class_solver.solve_uL(obj.LHS,obj.RHS);

            R=K_RR*obj.uR+K_RL*obj.uL-Fext_R;

            u(obj.vL,1)=obj.uL;
            u(obj.vR,1)=obj.uR;

            %% UL UNIT TESTING

            unit_testing_uL(obj.uL);

        end
    end
end