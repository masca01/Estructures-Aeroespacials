classdef computeKelBar < mainA02

    methods (Access = public)

        function Kel = compute(~,n_el_dof,n_el,x,Tn,mat,Tmat)

            Kel=zeros(n_el_dof,n_el_dof,n_el);
            %K=zeros(n_el_dof,n_el_dof);

            for e=1:n_el
                x1=x(Tn(e,1),1);
                x2=x(Tn(e,2),1);
                y1=x(Tn(e,1),2);
                y2=x(Tn(e,2),2);
                z1=x(Tn(e,1),3);
                z2=x(Tn(e,2),3);

                l=sqrt((x2-x1)^2+(y2-y1)^2+(z2-z1)^2);

                R = (1/l).*[x2-x1 y2-y1 z2-z1 0 0 0;
                    0 0 0 x2-x1 y2-y1 z2-z1];

                K_ = (mat(Tmat(e),1)*mat(Tmat(e),2)./l).*[1 -1;
                    -1 1];
                K = transpose(R)*K_*R;

                for r=1:(n_el_dof)
                    for s=1:(n_el_dof)
                        Kel(r,s,e)=K(r,s);
                    end
                end
            end
        end
    end
end