%--------------------------------------------------------------------------
% PLOTBARSTRESS3D function.
% Inputs:                                           Type [Dimensions]
% - x      Nodal coordinates matrix (in m)          matrix [ n    , nd   ]
% - Tn   Nodal connectivities matrix              matrix [ nel  , nnod ]
% - u      Array with global displacements (in m)   array  [ ndof ]
% - sig    Array with stress for each bar (in Pa)   array  [ nel  ]
% - scale  Scale factor for the displacements       scalar
%--------------------------------------------------------------------------

classdef plotBarStress3D < mainA02

    methods (Access = public)

        function plot(obj,u,sig,scale)

            % Precomputations
            nd = size(obj.x,2);
            X = obj.x(:,1);
            Y = obj.x(:,2);
            Z = obj.x(:,3);
            ux = u(1:nd:end);
            uy = u(2:nd:end);
            uz = u(3:nd:end);

            % Initialize figure
            figure
            hold on
            axis equal;
            colormap jet;

            % Plot undeformed structure
            plot3(X(obj.Tn)',Y(obj.Tn)',Z(obj.Tn)','-k','linewidth',0.5);

            % Plot deformed structure with stress colormapped
            patch(X(obj.Tn)'+scale*ux(obj.Tn)',Y(obj.Tn)'+scale*uy(obj.Tn)',Z(obj.Tn)'+scale*uz(obj.Tn)',[sig';sig'],'edgecolor','flat','linewidth',2);

            % View angle
            view(45,20);

            % Add axes labels
            xlabel('x (m)')
            ylabel('y (m)')
            zlabel('z (m)')

            % Add title
            title(sprintf('Deformed structure (scale = %g)',scale));

            % Add colorbar
            cbar = colorbar('Ticks',linspace(min(sig),max(sig),5));
            title(cbar,{'Stress';'(Pa)'});

        end
    end
end