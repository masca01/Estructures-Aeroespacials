function KG = assemblyKG(n_el,n_el_dof,n_dof,Td,Kel)

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