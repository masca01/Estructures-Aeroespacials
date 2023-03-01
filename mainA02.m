classdef mainA02 < handle

    properties (Access = public)
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

        L = 1614.45285;

        WM
        D
        x
        Tn
        fixNod
        mat
        Tmat

        % Dimensions
        n_d             % Number of dimensions
        n_i                 % Number of DOFs for each node
        n               % Total number of nodes
        n_dof               % Total number of degrees of freedom
        n_el          % Total number of elements
        n_nod          % Number of nodes for each element
        n_el_dof       % Number of DOFs for each element

    end


    methods (Access = public)

        function obj = mainA02()

            obj.WM = obj.M * obj.g;

            obj.D = obj.T;

            %% PREPROCESS

            % Nodal coordinates matrix
            %  x(a,j) = coordinate of node a in the dimension j
            obj.x = [%     X      Y      Z
                2*obj.W,  -obj.W/2,     0; % (1)
                2*obj.W,   obj.W/2,     0; % (2)
                2*obj.W,     0,     obj.H; % (3)
                0,     0,     obj.H; % (4)
                0,    -obj.B,     obj.H; % (5)
                0,     obj.B,     obj.H; % (6)
                obj.W,     0,     obj.H; % (7)
                ];

            % Nodal connectivities
            %  Tn(e,a) = global nodal number associated to node a of element e
            obj.Tn = [1 2; %1
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
            obj.fixNod = [1 3 0;
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
            obj.mat = [% Young M.        Section A.    Density   D     d
                75000*10^(6),  pi*((obj.D1-obj.d1)/2)^2,  3350,   obj.D1,   obj.d1;  % Material (1)
                147000*10^(6), pi*((obj.D2-obj.d2)/2)^2,  950,    obj.D2,   obj.d2;% Material (2)
                ];

            % Material connectivities
            %  Tmat(e) = Row in mat corresponding to the material associated to element e
            obj.Tmat = [1;1;1;1;1;1;1;1;1;1;1;2;2;2;2;2;2
                ];

            % Dimensions
            obj.n_d = size(obj.x,2);              % Number of dimensions
            obj.n_i = obj.n_d;                    % Number of DOFs for each node
            obj.n = size(obj.x,1);                % Total number of nodes
            obj.n_dof = obj.n_i*obj.n;                % Total number of degrees of freedom
            obj.n_el = size(obj.Tn,1);            % Total number of elements
            obj.n_nod = size(obj.Tn,2);           % Number of nodes for each element
            obj.n_el_dof = obj.n_i*obj.n_nod;         % Number of DOFs for each element

        end

    end
    

    methods (Static)

        function main()

            %% SOLVER

            % Computation of the DOFs connectivities
            class_connectDOFs = connectDOFs();
            Td = class_connectDOFs.connect();

            % Computation of element stiffness matrices
            class_computeKelBar = computeKelBar();
            Kel = class_computeKelBar.compute();

            % Global matrix assembly
            class_assemblyKG = assemblyKG();
            KG = class_assemblyKG.assembly(Td,Kel);

            % Global force vector assembly
            class_computeF = computeF();
            Fext = class_computeF.compute();

            % Apply conditions
            class_applyCond = applyCond();
            [vL,vR,uR] = class_applyCond.apply();

            method = 'Direct'; %'Direct' or 'Iterative' for uL calculation.

            % System resolution
            class_solveSys = solveSys(method);
            [u,~] = class_solveSys.calc(vL,vR,uR,KG,Fext);
            %[u,R] = class_solveSys.calc(vL,vR,uR,KG,Fext);

            % Compute strain and stresses
            class_computeStrainStressBar = computeStrainStressBar();
            [sig,~] = class_computeStrainStressBar.compute(u,Td);
            %[sig,eps] = class_computeStrainStressBar.compute(obj.n_el,obj.n_el_dof,u,Td,obj.x,obj.Tn,obj.mat,obj.Tmat);


            %% POSTPROCESS

            % Plot deformed structure with stress of each bar
            scale = 20; % Adjust this parameter for properly visualizing the deformation

            class_plotBarStress3D = plotBarStress3D();
            class_plotBarStress3D.plot(u,sig,scale);

        end

    end
end