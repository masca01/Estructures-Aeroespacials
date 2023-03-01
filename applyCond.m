%--------------------------------------------------------------------------
% The function takes as inputs:
%   - Dimensions:  n_i      Number of DOFs per node
%                  n_dof    Total number of DOFs
%   - fixNod  Prescribed displacements data [Npresc x 3]
%              fixNod(k,1) - Node at which the some DOF is prescribed
%              fixNod(k,2) - DOF (direction) at which the prescription is applied
%              fixNod(k,3) - Prescribed displacement magnitude in the corresponding DOF
%--------------------------------------------------------------------------
% It must provide as output:
%   - vL      Free degree of freedom vector
%   - vR      Prescribed degree of freedom vector
%   - uR      Prescribed displacement vector
%--------------------------------------------------------------------------
% Hint: Use the relation between the DOFs numbering and nodal numbering to
% determine at which DOF in the global system each displacement is prescribed.
%--------------------------------------------------------------------------

classdef applyCond < mainA02

    methods (Access = public)

        function [vL,vR,uR] = apply(obj)

            %vL = zeros(n_dof-size(fixNod,1), 1);
            vR = zeros(size(obj.fixNod,1),1);
            uR = zeros(size(obj.fixNod,1),1);

            for i=1:size(obj.fixNod,1)

                if obj.fixNod(i,2)==1
                    vR(i)=obj.fixNod(i,1)*obj.n_i-2;
                elseif obj.fixNod(i,2)==2
                    vR(i)=obj.fixNod(i,1)*obj.n_i-1;
                else
                    vR(i)=obj.fixNod(i,1)*obj.n_i;
                end

            end

            for i = 1 : size(obj.fixNod,1)
                uR(i,1) = obj.fixNod(i,3);
            end

            e = 1 : obj.n_dof;
            e(vR) = [];
            vL = transpose(e);

        end
    end
end
