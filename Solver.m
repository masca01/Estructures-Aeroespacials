classdef Solver

   properties (Access = public)
      RHS
      LHS
      method
   end

   methods (Access = public)

       function obj = Solver(LHS,RHS,method)
           obj.LHS = LHS;
           obj.RHS = RHS;
           obj.method = method;
       end

       function uL = operacio(obj) % uL = inv(K_LL)*(Fext_L-K_LR*uR); --> K_LL * uL = (Fext_L-K_LR*uR)

          switch (obj.method)

              case {'Iterative'}

                    uL = pcg(obj.LHS,obj.RHS,1e-06,20); % IterativeSolver x = pcg(A,b) attempts to solve the system of linear equations A*x = b

              case {'Direct'}

                    uL = obj.LHS\obj.RHS; % DirectSolver
            
              otherwise

                  disp('Wrong method in uL calculation.')

          end

            
        end

         

      end

end