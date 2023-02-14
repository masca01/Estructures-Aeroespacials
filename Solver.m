classdef Solver < solveSys

    methods (Access = public)

        function uL = solve_uL(obj)

            obj = obj.method;

            switch (obj.method)

                case {'Direct'}

                    class1 = DirectSolver(obj);
                    uL = class1.directsolve();

                case {'Iterative'}

                    class2 = IterativeSolver(obj);
                    uL = class2.iterativesolve();

                otherwise

                    disp('Wrong method in uL calculation.')

            end
        end
    end
end