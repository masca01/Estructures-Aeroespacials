classdef DirectSolver < Solver

    methods (Access = public)

        function uL = directSolve(obj,LHS,RHS)

            obj.LHS = LHS;
            obj.RHS = RHS;

            uL = obj.LHS\obj.RHS;

        end
    end
end