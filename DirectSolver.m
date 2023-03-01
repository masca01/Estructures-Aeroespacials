classdef DirectSolver < Solver

    methods (Access = public)

        function uL = directsolve(obj,LHS,RHS)

            obj.LHS = LHS;
            obj.RHS = RHS;

            uL = obj.LHS\obj.RHS;

        end
    end
end