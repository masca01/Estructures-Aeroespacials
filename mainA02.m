classdef MainA02 < handle

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
        nD             % Number of dimensions
        nI                 % Number of DOFs for each node
        n               % Total number of nodes
        nDof               % Total number of degrees of freedom
        nEl          % Total number of elements
        nNod          % Number of nodes for each element
        nElDof       % Number of DOFs for each element

        method = 'Direct'; %'Direct' or 'Iterative' for uL calculation.

        Td
        Kel
        KG
        Fext
        FandM
        vL
        vR
        uR
        u
        R
        sig
        eps

    end


    methods (Access = public)

        function obj = MainA02()

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
            obj.nD = size(obj.x,2);              % Number of dimensions
            obj.nI = obj.nD;                    % Number of DOFs for each node
            obj.n = size(obj.x,1);                % Total number of nodes
            obj.nDof = obj.nI*obj.n;                % Total number of degrees of freedom
            obj.nEl = size(obj.Tn,1);            % Total number of elements
            obj.nNod = size(obj.Tn,2);           % Number of nodes for each element
            obj.nElDof = obj.nI*obj.nNod;         % Number of DOFs for each element

        end


        function main(obj)

            %% SOLVER

            % Computation of the DOFs connectivities
            classDOFsConnector = DOFsConnector();
            obj.Td = classDOFsConnector.connectDOFs();

            % Computation of element stiffness matrices
            classKelBarComputer = KelBarComputer();
            obj.Kel = classKelBarComputer.computeKelBar();

            % Global matrix assembly
            classAssemblyKG = AssemblyKG();
            obj.KG = classAssemblyKG.assembleKG(obj.Td,obj.Kel);

            % Global force vector assembly
            classFComputer = FComputer();
            [obj.Fext, obj.FandM] = classFComputer.computeF();

            % Apply conditions
            classCondApplication = CondApplication();
            [obj.vL,obj.vR,obj.uR] = classCondApplication.applyCond();


            % System resolution
            classSysSolver = SysSolver();
            [obj.u,obj.R] = classSysSolver.solveSys(obj.vL,obj.vR,obj.uR,obj.KG,obj.Fext);

            % Compute strain and stresses
            classStrainStressBarComputer = StrainStressBarComputer();
            [obj.sig,obj.eps] = classStrainStressBarComputer.computeStrainStressBar(obj.u,obj.Td);


            %% POSTPROCESS

            % Plot deformed structure with stress of each bar
            scale = 20; % Adjust this parameter for properly visualizing the deformation

            classBarStress3DPlotter = BarStress3DPlotter();
            classBarStress3DPlotter.plotBarStress3D(obj.u,obj.sig,scale);

        end
    end
end