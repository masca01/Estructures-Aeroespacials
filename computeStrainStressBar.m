%--------------------------------------------------------------------------
% The function takes as inputs:
%   - Dimensions:  n_d        Problem's dimensions
%                  n_el       Total number of elements
%   - u     Global displacement vector [n_dof x 1]
%            u(I) - Total displacement on global DOF I
%   - Td    DOFs connectivities table [n_el x n_el_dof]
%            Td(e,i) - DOF i associated to element e
%   - x     Nodal coordinates matrix [n x n_d]
%            x(a,i) - Coordinates of node a in the i dimension
%   - Tn    Nodal connectivities table [n_el x n_nod]
%            Tn(e,a) - Nodal number associated to node a of element e
%   - mat   Material properties table [Nmat x NpropertiesXmat]
%            mat(m,1) - Young modulus of material m
%            mat(m,2) - Section area of material m
%   - Tmat  Material connectivities table [n_el]
%            Tmat(e) - Material index of element e
%--------------------------------------------------------------------------
% It must provide as output:
%   - eps   Strain vector [n_el x 1]
%            eps(e) - Strain of bar e
%   - sig   Stress vector [n_el x 1]
%            sig(e) - Stress of bar e
%--------------------------------------------------------------------------

classdef computeStrainStressBar < mainA02

    methods (Access = public)

        function [sig,eps] = compute(~,n_el,n_el_dof,u,Td,x,Tn,mat,Tmat)

            ue = zeros(n_el_dof,1);
            eps = zeros(n_el,1);
            sig = zeros(n_el,1);

            for e = 1 : n_el

                x1 = x(Tn(e,1),1);
                x2 = x(Tn(e,2),1);
                y1 = x(Tn(e,1),2);
                y2 = x(Tn(e,2),2);
                z1 = x(Tn(e,1),3);
                z2 = x(Tn(e,2),3);

                l = sqrt((x2-x1)^2 + (y2-y1)^2 + (z2-z1)^2);

                R = (1/l).*[x2-x1 y2-y1 z2-z1 0 0 0;
                    0 0 0 x2-x1 y2-y1 z2-z1];

                for i = 1 : (n_el_dof)

                    I = Td(e,i);
                    ue(i,1) = u(I);

                end

                u_e = R * ue;

                eps(e,1) = (1/l).*[-1 1] * u_e;
                sig(e,1) = (mat(Tmat(e),1)) * eps(e,1);


                In = (pi/4) * (((mat(Tmat(e),4))/2)^4 - ((mat(Tmat(e),5))/2)^4);

                sig_cr = (pi^2 * (mat(Tmat(e),1)) * In) / (l^2 * (mat(Tmat(e),2)));

                if sig(e) < 0 && abs((sig(e))) >= sig_cr
                    disp("Caution! Bar number " + e + " will bend.")
                end

            end
        end
    end
end