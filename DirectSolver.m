classdef DirectSolver

   properties (Access = public)
      RHS
      LHS
   end

   methods (Access = public)

       
       function obj = DirectSolver(LHS,RHS)
           obj.LHS = LHS;
           obj.RHS = RHS;
       end

           function uL = operacio(obj)
            uL = obj.LHS\obj.RHS;
        end

         % uL = inv(K_LL)*(Fext_L-K_LR*uR);

      end

end