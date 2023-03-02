%--------------------------------------------------------------------------
% The function takes as inputs:
%   - Dimensions:  nI         Number of DOFs per node
%                  nDof       Total number of DOFs
%   - Fdata  External nodal forces [Nforces x 3]
%            Fdata(k,1) - Node at which the force is applied
%            Fdata(k,2) - DOF (direction) at which the force acts
%            Fdata(k,3) - Force magnitude in the corresponding DOF
%--------------------------------------------------------------------------
% It must provide as output:
%   - Fext  Global force vector [nDof x 1]
%            Fext(I) - Total external force acting on DOF I
%--------------------------------------------------------------------------
% Hint: Use the relation between the DOFs numbering and nodal numbering to
% determine at which DOF in the global system each force is applied.
%--------------------------------------------------------------------------

classdef FComputer < MainA02

    methods (Access = public)

        function [Fext,FandM] = computeF(obj)


            Fext = zeros(obj.nDof,1);

            %THRUST

            Fext(1,1) = obj.T/2;
            Fext(4,1) = obj.T/2;

            %PES

            Fext(3,1) = -obj.WM/2;
            Fext(6,1) = -obj.WM/2;

            %LIFT

            Fext(9,1) = obj.L/5;
            Fext(12,1) = obj.L/5;
            Fext(15,1) = obj.L/5;
            Fext(18,1) = obj.L/5;
            Fext(21,1) = obj.L/5;

            %DRAG

            Fext(7,1) = -obj.D/5;
            Fext(10,1) = -obj.D/5;
            Fext(13,1) = -obj.D/5;
            Fext(16,1) = -obj.D/5;
            Fext(19,1) = -obj.D/5;

            % PESO BARRAS
            for e=1:obj.nEl

                x1 = obj.x(obj.Tn(e,1),1);
                x2 = obj.x(obj.Tn(e,2),1);
                y1 = obj.x(obj.Tn(e,1),2);
                y2 = obj.x(obj.Tn(e,2),2);
                z1 = obj.x(obj.Tn(e,1),3);
                z2 = obj.x(obj.Tn(e,2),3);

                l = sqrt((x2-x1)^2+(y2-y1)^2+(z2-z1)^2);
                for n = 1 : obj.nNod
                    Fext(3*obj.Tn(e,n),1) = Fext(3*obj.Tn(e,n),1)-(l*(obj.mat(obj.Tmat(e),2))*(obj.mat(obj.Tmat(e),3))*obj.g)/obj.nNod;
                    Fext(3*obj.Tn(e,n),1) = Fext(3*obj.Tn(e,n),1)-(l*(obj.mat(obj.Tmat(e),2))*(obj.mat(obj.Tmat(e),3))*obj.g)/obj.nNod;
                end

            end

            [Fx,Fy,Fz,Mx,My,Mz] = findFandM(Fext,obj.nDof,obj.WM,obj.x);

            FandM = [Fx,Fy,Fz,Mx,My,Mz];

            unitTestingF(Fext);

        end
    end
end