%% KG UNIT TEST

function unitTestingKG(KG)

% save unitTesting.mat KG -v7.3;

unitTesting = load('unitTesting.mat');

errorKG = unitTesting.KG - KG;

[numRows,numCols] = size(errorKG);

for i = 1 : numRows

    for j = 1 : numCols

        if errorKG(i,j) == 0

        else
            disp("Error in stifness matrix assembly (KG) row "+ i +" column "+ j);
        end
    end
end