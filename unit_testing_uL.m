%% UL UNIT TESTING

function unit_testing_uL(uL)

% unit_testing = matfile('unit_testing.mat','Writable',true);
%
% unit_testing.uL = uL;

obj.uL = uL;

unit_testing = load('unit_testing.mat');

error_uL = unit_testing.uL - obj.uL;

[numRows,numCols] = size(error_uL);

for i = 1 : numRows

    for j = 1 : numCols

        if error_uL(i,j) < 1 * 10^(-7)

        else
            disp("Error in global displacement vector assembly (uL) row "+ i +" column "+ j);
        end
    end

end


