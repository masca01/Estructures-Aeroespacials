classdef DirectSolver < Solver

   methods (Access = public)

           function uL = directsolve(obj)

            uL = obj.LHS\obj.RHS;

        end

         % uL = inv(K_LL)*(Fext_L-K_LR*uR); --> K_LL * uL = (Fext_L-K_LR*uR)

      end

end