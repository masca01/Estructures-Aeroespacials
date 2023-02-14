classdef connectDOFs < handle

    methods (Access = public)

        function Td = connect(~,n,n_el,n_el_dof,n_d,Tn)

            Td=size(n_el,n_el_dof);
            FD=size(n,n_d);

            for i=1:n
                FD(i,1)=(3*i)-2;
                FD(i,2)=(3*i)-1;
                FD(i,3)=3*i;
            end

            for j=1:n_el
                x=Tn(j,1);
                y=Tn(j,2);
                x1=FD(x,1);
                x2=FD(x,2);
                x3=FD(x,3);
                y1=FD(y,1);
                y2=FD(y,2);
                y3=FD(y,3);
                %     Td(j,:)=[x1,x2,x3,y1,y2,y3];
                Td(j,1)=x1;
                Td(j,2)=x2;
                Td(j,3)=x3;
                Td(j,4)=y1;
                Td(j,5)=y2;
                Td(j,6)=y3;
            end
        end
    end
end