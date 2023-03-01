%% KG UNIT TEST

function unit_testing_KG(KG)

% save unit_testing.mat KG -v7.3;

unit_testing = load('unit_testing.mat');

error_KG = unit_testing.KG - KG;

[numRows,numCols] = size(error_KG);

for i = 1 : numRows

    for j = 1 : numCols

        if error_KG(i,j) == 0

        else
            disp("Error in stifness matrix assembly (KG) row "+ i +" column "+ j);
        end
    end
end