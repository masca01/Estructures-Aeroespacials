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

        function Fext = computeF(obj)


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

            Fx = 0;
            Fy = 0;
            Fz = 0;

            % SUMATORIO DE FUERZAS EN X

            for xm = 1 : 3 : obj.nDof
                Fx = Fx+Fext(xm,1);
            end

            ax = Fx/(obj.WM/9.81);

            Fx = Fx - ax*(obj.WM/9.81);

            % SUMATORIO DE FUERZAS EN Y

            for y = 2 : 3 : obj.nDof
                Fy = Fy+Fext(y,1);
            end

            % SUMATORIO DE FUERZAS EN Z

            for z = 3 : 3 : obj.nDof
                Fz = Fz + Fext(z,1);
            end

            Mx = 0;
            My = 0;
            Mz = 0;

            % SUMATORIO DE MOMENTOS EN X

            for xm = 1 : 3 : obj.nDof
                Mx = Mx + Fext(xm+2,1)*(obj.x((xm+2)/3,2)-obj.x(3,2));
            end

            % SUMATORIO DE MOMENTOS EN Y

            for y = 2 : 3 : obj.nDof
                My = My + Fext(y-1,1)*(obj.x((y+1)/3,3)-obj.x(3,3))-Fext(y+1,1)*(obj.x((y+1)/3,1)-obj.x(3,1));
            end      %    Fx            Dz                 Fz               Dx

            % SUMATORIO DE MOMENTOS EN Z

            for z = 3 : 3 : obj.nDof
                Mz = Mz + Fext(z-2,1)*(obj.x(z/3,2)-obj.x(3,2));
            end

            unitTestingF(Fext);

        end
    end
end