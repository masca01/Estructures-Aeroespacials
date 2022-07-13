function Fext = computeF(n_el,n_dof,n_nod,T,WM,L,D,mat,Tmat,Tn,x,g)
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

Fext=zeros(n_dof,1);

%THRUST

Fext(1,1)=T/2;
Fext(4,1)=T/2;

%PES

Fext(3,1)=-WM/2;
Fext(6,1)=-WM/2;

%LIFT

Fext(9,1)=L/5;
Fext(12,1)=L/5;
Fext(15,1)=L/5;
Fext(18,1)=L/5;
Fext(21,1)=L/5;

%DRAG

Fext(7,1)=-D/5;
Fext(10,1)=-D/5;
Fext(13,1)=-D/5;
Fext(16,1)=-D/5;
Fext(19,1)=-D/5;

% PESO BARRAS
for e=1:n_el

    x1=x(Tn(e,1),1);
    x2=x(Tn(e,2),1);
    y1=x(Tn(e,1),2);
    y2=x(Tn(e,2),2);
    z1=x(Tn(e,1),3);
    z2=x(Tn(e,2),3);

    l=sqrt((x2-x1)^2+(y2-y1)^2+(z2-z1)^2);
for n=1:n_nod
    Fext(3*Tn(e,n),1)=Fext(3*Tn(e,n),1)-(l*(mat(Tmat(e),2))*(mat(Tmat(e),3))*g)/n_nod;
    Fext(3*Tn(e,n),1)=Fext(3*Tn(e,n),1)-(l*(mat(Tmat(e),2))*(mat(Tmat(e),3))*g)/n_nod;
end

end

Fx=0;
Fy=0;
Fz=0;

% SUMATORIO DE FUERZAS EN X

for xm=1:3:n_dof
    Fx=Fx+Fext(xm,1);
end

% SUMATORIO DE FUERZAS EN Y

for y=2:3:n_dof
    Fy=Fy+Fext(y,1);
end

% SUMATORIO DE FUERZAS EN Z

for z=3:3:n_dof
    Fz=Fz+Fext(z,1);
end

Mx=0;
My=0;
Mz=0;

% SUMATORIO DE MOMENTOS EN X

for xm=1:3:n_dof
    Mx=Mx+Fext(xm+2,1)*(x((xm+2)/3,2)-x(3,2));
end

% SUMATORIO DE MOMENTOS EN Y

for y=2:3:n_dof
    My=My+Fext(y-1,1)*(x((y+1)/3,3)-x(3,3))-Fext(y+1,1)*(x((y+1)/3,1)-x(3,1));
end      %    Fx            Dz                 Fz               Dx

% SUMATORIO DE MOMENTOS EN Z

for z=3:3:n_dof
    Mz=Mz+Fext(z-2,1)*(x(z/3,2)-x(3,2));
end

%Prova de github amb els canvis.





