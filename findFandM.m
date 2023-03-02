function [Fx,Fy,Fz,Mx,My,Mz] = findFandM(Fext,nDof,WM,x)

Fx = 0;
Fy = 0;
Fz = 0;

% SUMATORIO DE FUERZAS EN X

for xm = 1 : 3 : nDof
    Fx = Fx + Fext(xm,1);
end

ax = Fx/(WM/9.81);

Fx = Fx - ax*(WM/9.81);

% SUMATORIO DE FUERZAS EN Y

for y = 2 : 3 : nDof
    Fy = Fy + Fext(y,1);
end

% SUMATORIO DE FUERZAS EN Z

for z = 3 : 3 : nDof
    Fz = Fz + Fext(z,1);
end

Mx = 0;
My = 0;
Mz = 0;

% SUMATORIO DE MOMENTOS EN X

for xm = 1 : 3 : nDof
    Mx = Mx + Fext(xm+2,1)*(x((xm+2)/3,2)-x(3,2));
end

% SUMATORIO DE MOMENTOS EN Y

for y = 2 : 3 : nDof
    My = My + Fext(y-1,1)*(x((y+1)/3,3)-x(3,3))-Fext(y+1,1)*(x((y+1)/3,1)-x(3,1));
end      %    Fx            Dz                 Fz               Dx

% SUMATORIO DE MOMENTOS EN Z

for z = 3 : 3 : nDof
    Mz = Mz + Fext(z-2,1)*(x(z/3,2)-x(3,2));
end