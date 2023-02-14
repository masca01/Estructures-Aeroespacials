%-------------------------------------------------------------------------%
% ASSIGNMENT 02
%-------------------------------------------------------------------------%
% Date:
% Author/s: VALERI
%


clear;
close all;

%% INPUT DATA

% Geometric data
H = 0.9;
W = 0.85;
B = 3.2;
D1 = 18*10^(-3); 
d1 = 7.5*10^(-3);
D2 = 3*10^(-3);
d2 = 0;

% Mass
M = 150;

% Thrust
T = 1962.8882;

% Other
g = 9.81;

WM = M * g;

L = 1614.45285;

D = T;

%% PREPROCESS

% Nodal coordinates matrix 
%  x(a,j) = coordinate of node a in the dimension j
x = [%     X      Y      Z
         2*W,  -W/2,     0; % (1)
         2*W,   W/2,     0; % (2)
         2*W,     0,     H; % (3)
           0,     0,     H; % (4)
           0,    -B,     H; % (5)
           0,     B,     H; % (6)
           W,     0,     H; % (7)
];

% Nodal connectivities  
%  Tn(e,a) = global nodal number associated to node a of element e
Tn = [1 2; %1
    2 3; %2
    1 3; %3
    3 5; %4
    3 6; %5
    3 7; %6
    4 5; %7
    4 6; %8
    4 7; %9
    5 7; %10
    6 7; %11
    1 4; %12
    1 5; %13
    1 7; %14
    2 4; %15
    2 6; %16
    2 7; %17
];

% Fix nodes matrix creation
%  fixNod(k,1) = node at which some DOF is prescribed
%  fixNod(k,2) = DOF prescribed
%  fixNod(k,3) = prescribed displacement in the corresponding DOF (0 for fixed)
fixNod = [1 3 0;
          3 1 0;
          3 2 0;
          3 3 0;   
          4 2 0;
          4 3 0  
              ];

% Material properties matrix
%  mat(m,1) = Young modulus of material m
%  mat(m,2) = Section area of material m
%  mat(m,3) = Density of material m
%  --more columns can be added for additional material properties--
mat = [% Young M.        Section A.    Density   D     d
       75000*10^(6),  pi*((D1-d1)/2)^2,  3350,   D1,   d1;  % Material (1)
       147000*10^(6), pi*((D2-d2)/2)^2,  950,    D2,   d2;% Material (2)
];

% Material connectivities
%  Tmat(e) = Row in mat corresponding to the material associated to element e 
Tmat = [1;1;1;1;1;1;1;1;1;1;1;2;2;2;2;2;2
  ];

%% SOLVER

% Dimensions
n_d = size(x,2);              % Number of dimensions
n_i = n_d;                    % Number of DOFs for each node
n = size(x,1);                % Total number of nodes
n_dof = n_i*n;                % Total number of degrees of freedom
n_el = size(Tn,1);            % Total number of elements
n_nod = size(Tn,2);           % Number of nodes for each element
n_el_dof = n_i*n_nod;         % Number of DOFs for each element 

% Computation of the DOFs connectivities
Td = connectDOFs(n,n_el,n_el_dof,n_d,Tn);

% Computation of element stiffness matrices
Kel = computeKelBar(n_el_dof,n_el,x,Tn,mat,Tmat);

% Global matrix assembly
KG = assemblyKG(n_el,n_el_dof,n_dof,Td,Kel);

% Global force vector assembly
Fext = computeF(n_el,n_dof,n_nod,T,WM,L,D,mat,Tmat,Tn,x,g);

% Apply conditions 
[vL,vR,uR] = applyCond(n_dof,n_i,fixNod);

method = 'Direct'; %'Direct' or 'Iterative' for uL calculation.

% System resolution
class_solveSys = solveSys(method);
[u,R] = class_solveSys.calc(vL,vR,uR,KG,Fext);

% Compute strain and stresses
[sig,eps] = computeStrainStressBar(n_el,n_el_dof,u,Td,x,Tn,mat,Tmat);


%% POSTPROCESS

% Plot deformed structure with stress of each bar
scale = 20; % Adjust this parameter for properly visualizing the deformation
plotBarStress3D(x,Tn,u,sig,scale);


