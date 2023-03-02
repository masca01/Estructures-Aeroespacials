%% UL UNIT TESTING

function unitTestingUL(uL)

% unitTesting = matfile('unitTesting.mat','Writable',true);
% 
% unitTesting.uL = uL;

obj.uL = uL;

unitTesting = load('unitTesting.mat');

errorUL = unitTesting.uL - obj.uL;

[numRows,numCols] = size(errorUL);

for i = 1 : numRows

    for j = 1 : numCols

        if errorUL(i,j) < 1 * 10^(-7)

        else
            disp("Error in global displacement vector assembly (uL) row "+ i +" column "+ j);
        end
    end

end


