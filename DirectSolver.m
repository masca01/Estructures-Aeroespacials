classdef DirectSolver

   properties (Access = private)
      K_LL
      Fext_L
      K_LR
      uR
   end

   methods (Access = public)

       
       function obj = DirectSolver(K_LL,Fext_L,K_LR,uR)

           obj.K_LL = K_LL;
           obj.Fext_L = Fext_L;
           obj.K_LR = K_LR;
           obj.uR = uR;
       end

           function uL = operacio(obj)
            uL = inv(obj.K_LL)*(obj.Fext_L-obj.K_LR*obj.uR);
        end

         % uL = inv(K_LL)*(Fext_L-K_LR*uR);

      end

end