classdef KelBarComputer < MainA02

    methods (Access = public)

        function Kel = computeKelBar(obj)

            Kel=zeros(obj.nElDof,obj.nElDof,obj.nEl);
            %K=zeros(nElDof,nElDof);

            for e=1:obj.nEl
                x1=obj.x(obj.Tn(e,1),1);
                x2=obj.x(obj.Tn(e,2),1);
                y1=obj.x(obj.Tn(e,1),2);
                y2=obj.x(obj.Tn(e,2),2);
                z1=obj.x(obj.Tn(e,1),3);
                z2=obj.x(obj.Tn(e,2),3);

                l=sqrt((x2-x1)^2+(y2-y1)^2+(z2-z1)^2);

                R = (1/l).*[x2-x1 y2-y1 z2-z1 0 0 0;
                    0 0 0 x2-x1 y2-y1 z2-z1];

                K_ = (obj.mat(obj.Tmat(e),1)*obj.mat(obj.Tmat(e),2)./l).*[1 -1;
                    -1 1];
                K = transpose(R)*K_*R;

                for r=1:(obj.nElDof)
                    for s=1:(obj.nElDof)
                        Kel(r,s,e)=K(r,s);
                    end
                end
            end
        end
    end
end