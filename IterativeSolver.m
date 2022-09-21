classdef IterativeSolver

   properties (Access = public)
      RHS
      LHS
   end

   methods (Access = public)

       
       function obj = IterativeSolver(LHS,RHS)
           obj.LHS = LHS;
           obj.RHS = RHS;
       end

           function uL = operacio(obj)

            uL = pcg(obj.LHS,obj.RHS,1e-06,20); %x = pcg(A,b) attempts to solve the system of linear equations A*x = b
        end

         % uL = inv(K_LL)*(Fext_L-K_LR*uR); --> K_LL * uL = (Fext_L-K_LR*uR)

      end

end