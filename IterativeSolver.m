classdef IterativeSolver < Solver

    methods (Access = public)

        function uL = iterativesolve(obj,LHS,RHS)

            obj.LHS = LHS;
            obj.RHS = RHS;

            uL = pcg(obj.LHS,obj.RHS,1e-07,20); %x = pcg(A,b) attempts to solve the system of linear equations A*x = b

            % uL = inv(K_LL)*(Fext_L-K_LR*uR); % --> K_LL * uL = (Fext_L-K_LR*uR)

        end
    end
end