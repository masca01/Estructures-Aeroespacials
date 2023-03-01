classdef connectDOFs < mainA02

    methods (Access = public)

        function Td = connect(obj)
            
            Td=size(obj.n_el,obj.n_el_dof);
            FD=size(obj.n,obj.n_d);

            for i = 1 : obj.n
                FD(i,1)=(3*i)-2;
                FD(i,2)=(3*i)-1;
                FD(i,3)=3*i;
            end

            for j = 1 : obj.n_el
                x=obj.Tn(j,1);
                y=obj.Tn(j,2);
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