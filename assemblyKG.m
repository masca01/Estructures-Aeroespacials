classdef assemblyKG < mainA02

    methods (Access = public)

        function KG = assembly(obj,Td,Kel)

            obj.Td = Td;
            obj.Kel = Kel;

            KG=zeros(obj.n_dof,obj.n_dof);

            for e=1:obj.n_el

                for i=1:obj.n_el_dof

                    I=Td(e,i);

                    for j=1:obj.n_el_dof

                        J=Td(e,j);
                        KG(I,J)=KG(I,J)+Kel(i,j,e);

                    end
                end
            end

            unit_testing_KG(KG)

        end
    end
end