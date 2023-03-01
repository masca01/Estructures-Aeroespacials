classdef Solver < solveSys

    methods (Access = public)

        function uL = solve_uL(obj,LHS,RHS)

            obj.LHS = LHS;
            obj.RHS = RHS;

            switch (obj.method)

                case {'Direct'}

                    class1 = DirectSolver();
                    uL = class1.directsolve(obj.LHS,obj.RHS);

                case {'Iterative'}

                    class2 = IterativeSolver();
                    uL = class2.iterativesolve(obj.LHS,obj.RHS);

                otherwise

                    disp('Wrong method in uL calculation.')

            end
        end
    end
end