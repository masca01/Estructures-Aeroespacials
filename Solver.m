classdef Solver < handle

   properties (Access = public)
      LHS
      RHS
      method
   end

   methods (Access = public)

       function obj = Solver(LHS,RHS,method)
           obj.LHS = LHS;
           obj.RHS = RHS;
           obj.method = method;
       end

       function uL = solve(obj)

          switch (obj.method)

              case {'Direct'}

                  class1 = DirectSolver(obj.LHS,obj.RHS,obj.method);
                  uL = class1.directsolve();
           
              case {'Iterative'}

                class2 = IterativeSolver(obj.LHS,obj.RHS,obj.method);
                uL = class2.solve();
            
              otherwise

                  disp('Wrong method in uL calculation.')

          end
       end
   end
end