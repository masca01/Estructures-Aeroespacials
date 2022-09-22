classdef IterativeSolver < Solver

   methods (Access = public)

           function uL = iterativesolve(obj)

            uL = pcg(obj.LHS,obj.RHS,1e-06,20); %x = pcg(A,b) attempts to solve the system of linear equations A*x = b

        end

         % uL = inv(K_LL)*(Fext_L-K_LR*uR); --> K_LL * uL = (Fext_L-K_LR*uR)

      end

end