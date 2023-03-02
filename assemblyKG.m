classdef AssemblyKG < MainA02

    methods (Access = public)

        function KG = assembleKG(obj,Td,Kel)

            obj.Td = Td;
            obj.Kel = Kel;

            KG=zeros(obj.nDof,obj.nDof);

            for e=1:obj.nEl

                for i=1:obj.nElDof

                    I=Td(e,i);

                    for j=1:obj.nElDof

                        J=Td(e,j);
                        KG(I,J)=KG(I,J)+Kel(i,j,e);

                    end
                end
            end

            unitTestingKG(KG)

        end
    end
end