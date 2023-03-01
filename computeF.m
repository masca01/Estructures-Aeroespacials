%--------------------------------------------------------------------------
% The function takes as inputs:
%   - Dimensions:  n_i         Number of DOFs per node
%                  n_dof       Total number of DOFs
%   - Fdata  External nodal forces [Nforces x 3]
%            Fdata(k,1) - Node at which the force is applied
%            Fdata(k,2) - DOF (direction) at which the force acts
%            Fdata(k,3) - Force magnitude in the corresponding DOF
%--------------------------------------------------------------------------
% It must provide as output:
%   - Fext  Global force vector [n_dof x 1]
%            Fext(I) - Total external force acting on DOF I
%--------------------------------------------------------------------------
% Hint: Use the relation between the DOFs numbering and nodal numbering to
% determine at which DOF in the global system each force is applied.
%--------------------------------------------------------------------------

classdef computeF < mainA02

    methods (Access = public)

        function Fext = compute(obj)


            Fext = zeros(obj.n_dof,1);

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
            for e=1:obj.n_el

                x1 = obj.x(obj.Tn(e,1),1);
                x2 = obj.x(obj.Tn(e,2),1);
                y1 = obj.x(obj.Tn(e,1),2);
                y2 = obj.x(obj.Tn(e,2),2);
                z1 = obj.x(obj.Tn(e,1),3);
                z2 = obj.x(obj.Tn(e,2),3);

                l = sqrt((x2-x1)^2+(y2-y1)^2+(z2-z1)^2);
                for n = 1 : obj.n_nod
                    Fext(3*obj.Tn(e,n),1) = Fext(3*obj.Tn(e,n),1)-(l*(obj.mat(obj.Tmat(e),2))*(obj.mat(obj.Tmat(e),3))*obj.g)/obj.n_nod;
                    Fext(3*obj.Tn(e,n),1) = Fext(3*obj.Tn(e,n),1)-(l*(obj.mat(obj.Tmat(e),2))*(obj.mat(obj.Tmat(e),3))*obj.g)/obj.n_nod;
                end

            end

            Fx = 0;
            Fy = 0;
            Fz = 0;

            % SUMATORIO DE FUERZAS EN X

            for xm = 1 : 3 : obj.n_dof
                Fx = Fx+Fext(xm,1);
            end

            ax = Fx/(obj.WM/9.81);

            Fx = Fx - ax*(obj.WM/9.81);

            % SUMATORIO DE FUERZAS EN Y

            for y = 2 : 3 : obj.n_dof
                Fy = Fy+Fext(y,1);
            end

            % SUMATORIO DE FUERZAS EN Z

            for z = 3 : 3 : obj.n_dof
                Fz = Fz + Fext(z,1);
            end

            Mx = 0;
            My = 0;
            Mz = 0;

            % SUMATORIO DE MOMENTOS EN X

            for xm = 1 : 3 : obj.n_dof
                Mx = Mx + Fext(xm+2,1)*(obj.x((xm+2)/3,2)-obj.x(3,2));
            end

            % SUMATORIO DE MOMENTOS EN Y

            for y = 2 : 3 : obj.n_dof
                My = My + Fext(y-1,1)*(obj.x((y+1)/3,3)-obj.x(3,3))-Fext(y+1,1)*(obj.x((y+1)/3,1)-obj.x(3,1));
            end      %    Fx            Dz                 Fz               Dx

            % SUMATORIO DE MOMENTOS EN Z

            for z = 3 : 3 : obj.n_dof
                Mz = Mz + Fext(z-2,1)*(obj.x(z/3,2)-obj.x(3,2));
            end

            %% F UNIT TESTING

            % unit_testing = matfile('unit_testing.mat','Writable',true);
            %
            % unit_testing.F = Fext;

            unit_testing = load('unit_testing.mat');

            error_F = unit_testing.F - Fext;

            [numRows,numCols] = size(error_F);

            for i = 1 : numRows

                for j = 1 : numCols

                    if error_F(i,j) == 0

                    else
                        disp("Error in external forces vector assembly (Fext) row "+ i +" column "+ j);
                    end
                end
            end
        end
    end
end

% function Fext = computeF(n_el,n_dof,n_nod,T,WM,L,D,mat,Tmat,Tn,x,g)
%
% Fext = zeros(n_dof,1);
%
% %THRUST
%
% Fext(1,1) = T/2;
% Fext(4,1) = T/2;
%
% %PES
%
% Fext(3,1) = -WM/2;
% Fext(6,1) = -WM/2;
%
% %LIFT
%
% Fext(9,1) = L/5;
% Fext(12,1) = L/5;
% Fext(15,1) = L/5;
% Fext(18,1) = L/5;
% Fext(21,1) = L/5;
%
% %DRAG
%
% Fext(7,1) = -D/5;
% Fext(10,1) = -D/5;
% Fext(13,1) = -D/5;
% Fext(16,1) = -D/5;
% Fext(19,1) = -D/5;
%
% % PESO BARRAS
% for e=1:n_el
%
%     x1 = x(Tn(e,1),1);
%     x2 = x(Tn(e,2),1);
%     y1 = x(Tn(e,1),2);
%     y2 = x(Tn(e,2),2);
%     z1 = x(Tn(e,1),3);
%     z2 = x(Tn(e,2),3);
%
%     l = sqrt((x2-x1)^2+(y2-y1)^2+(z2-z1)^2);
%     for n = 1 : n_nod
%         Fext(3*Tn(e,n),1) = Fext(3*Tn(e,n),1)-(l*(mat(Tmat(e),2))*(mat(Tmat(e),3))*g)/n_nod;
%         Fext(3*Tn(e,n),1) = Fext(3*Tn(e,n),1)-(l*(mat(Tmat(e),2))*(mat(Tmat(e),3))*g)/n_nod;
%     end
%
% end
%
% Fx = 0;
% Fy = 0;
% Fz = 0;
%
% % SUMATORIO DE FUERZAS EN X
%
% for xm = 1 : 3 : n_dof
%     Fx = Fx+Fext(xm,1);
% end
%
% ax = Fx/(WM/9.81);
%
% Fx = Fx - ax*(WM/9.81);
%
% % SUMATORIO DE FUERZAS EN Y
%
% for y = 2 : 3 : n_dof
%     Fy = Fy+Fext(y,1);
% end
%
% % SUMATORIO DE FUERZAS EN Z
%
% for z = 3 : 3 : n_dof
%     Fz = Fz + Fext(z,1);
% end
%
% Mx = 0;
% My = 0;
% Mz = 0;
%
% % SUMATORIO DE MOMENTOS EN X
%
% for xm = 1 : 3 : n_dof
%     Mx = Mx + Fext(xm+2,1)*(x((xm+2)/3,2)-x(3,2));
% end
%
% % SUMATORIO DE MOMENTOS EN Y
%
% for y = 2 : 3 : n_dof
%     My = My + Fext(y-1,1)*(x((y+1)/3,3)-x(3,3))-Fext(y+1,1)*(x((y+1)/3,1)-x(3,1));
% end      %    Fx            Dz                 Fz               Dx
%
% % SUMATORIO DE MOMENTOS EN Z
%
% for z = 3 : 3 : n_dof
%     Mz = Mz + Fext(z-2,1)*(x(z/3,2)-x(3,2));
% end
%
% %% F UNIT TESTING
%
% % unit_testing = matfile('unit_testing.mat','Writable',true);
% %
% % unit_testing.F = Fext;
%
% unit_testing = load('unit_testing.mat');
%
% error_F = unit_testing.F - Fext;
%
% [numRows,numCols] = size(error_F);
%
% for i = 1 : numRows
%
%     for j = 1 : numCols
%
%         if error_F(i,j) == 0
%
%         else
%             disp("Error in external forces vector assembly (Fext) row "+ i +" column "+ j);
%         end
%     end
% end