classdef DirectSolver < Solver

    methods (Access = public)

        function uL = directsolve(obj)

            obj = obj.method;

            uL = obj.LHS\obj.RHS;

        end
    end
end