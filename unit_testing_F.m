%% F UNIT TESTING

function unit_testing_F(Fext)

% unit_testing = matfile('unit_testing.mat','Writable',true);
%
% unit_testing.F = Fext;

unit_testing = load('unit_testing.mat');

error_F = unit_testing.F - Fext;

[numRows,numCols] = size(error_F);

for i = 1 : numRows

    for j = 1 : numCols

        if error_F(i,j) == 0

        else
            disp("Error in external forces vector assembly (Fext) row "+ i +" column "+ j);
        end
    end
end