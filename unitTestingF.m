%% F UNIT TESTING

function unitTestingF(Fext)

% unitTesting = matfile('unitTesting.mat','Writable',true);
% 
% unitTesting.F = Fext;

unitTesting = load('unitTesting.mat');

errorF = unitTesting.F - Fext;

[numRows,numCols] = size(errorF);

for i = 1 : numRows

    for j = 1 : numCols

        if errorF(i,j) == 0

        else
            disp("Error in external forces vector assembly (Fext) row "+ i +" column "+ j);
        end
    end
end