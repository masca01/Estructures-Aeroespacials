classdef IterativeSolver

   properties (Access = private)
      K_LL
      Fext_L
      K_LR
      uR
   end

   methods (Access = public)

       
       function obj = IterativeSolver(K_LL,Fext_L,K_LR,uR)

           obj.K_LL = K_LL;
           obj.Fext_L = Fext_L;
           obj.K_LR = K_LR;
           obj.uR = uR;
       end

           function uL = operacio(obj)

            LHS = obj.K_LL;

            RHS = (obj.Fext_L-obj.K_LR*obj.uR);

            uL = pcg(LHS,RHS,1e-06,20); %x = pcg(A,b) attempts to solve the system of linear equations A*x = b
        end

         % uL = inv(K_LL)*(Fext_L-K_LR*uR); --> K_LL * uL = (Fext_L-K_LR*uR)

      end

end