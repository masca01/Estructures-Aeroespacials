classdef assemblyKG < handle

     methods (Access = public)

        function KG = assembly(~,n_el,n_el_dof,n_dof,Td,Kel)

            KG=zeros(n_dof,n_dof);

            for e=1:n_el

                for i=1:n_el_dof

                    I=Td(e,i);

                    for j=1:n_el_dof

                        J=Td(e,j);
                        KG(I,J)=KG(I,J)+Kel(i,j,e);

                    end
                end
            end

            %% KG UNIT TEST

            % save unit_testing.mat KG -v7.3;

            unit_testing = load('unit_testing.mat');

            error_KG = unit_testing.KG - KG;

            [numRows,numCols] = size(error_KG);

            for i = 1 : numRows

                for j = 1 : numCols

                    if error_KG(i,j) == 0

                    else
                        disp("Error in stifness matrix assembly (KG) row "+ i +" column "+ j);
                    end
                end
            end
        end
    end
end