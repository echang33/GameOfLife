function [next_gen_mat] = GOL(in_mat)
%Advances GOL by 1 generation
%   Takes in current generation matrix as input, goes through GOL rules
%   Outputs the next generation matrix
rows = size(in_mat,1);
cols = size(in_mat,2);
next_gen_mat = zeros(rows,cols);

for i = 1:1:rows
    for j = 1:1:cols
    
    count = 0;
    
    % tests all 8 adjacent points, count # "alive"
    % if boundary point, skip the test
    if (i-1 > 0 && j-1 > 0) && in_mat(i-1,j-1) > 0 
        count = count + 1;
    end
    if (i-1 > 0) && in_mat(i-1,j) > 0
        count = count + 1;
    end
    if (i-1 > 0 && j+1 < cols) && in_mat(i-1,j+1) > 0
        count = count + 1;
    end
    if (j+1 < cols) && in_mat(i,j+1) > 0
        count = count + 1;
    end
    if (i+1 < rows && j+1 < cols) && in_mat(i+1,j+1) > 0
        count = count + 1;
    end
    if (i+1 < rows) && in_mat(i+1,j) > 0
        count = count + 1;
    end
    if (i+1 < rows && j-1 > 0) && in_mat(i+1,j-1) > 0
        count = count + 1;
    end 
    if (j-1 > 0) && in_mat(i,j-1) > 0
        count = count + 1;
    end

    % tests conditions/verifies rules, sets output values
    if in_mat(i,j) > 0
        if count < 2
            next_gen_mat(i,j) = 0;
        end
        if count == 2 || count == 3
            next_gen_mat(i,j) = 1;
        end
        if count > 3
            next_gen_mat(i,j) = 0;
        end
    else
        if count == 3
            next_gen_mat(i,j) = 1;
        end
    end
    end
end
    % Dynamically Expands Array
    for a = 1:1:rows
        if next_gen_mat(a,1) == 1
            next_gen_mat = padarray(next_gen_mat,[0,1],0,'pre');
            cols = size(next_gen_mat,2);
        end
        if next_gen_mat(a,cols) == 1
            next_gen_mat = padarray(next_gen_mat,[0,1],0,'post');
            cols = size(next_gen_mat,2);
        end
    end
    for b = 1:1:cols
        if next_gen_mat(1,b) == 1
            next_gen_mat = padarray(next_gen_mat,[1,0],0,'pre');
            rows = size(next_gen_mat,1);
        end
        if next_gen_mat(rows,b) == 1
            next_gen_mat = padarray(next_gen_mat,[1,0],0,'post');
            rows = size(next_gen_mat,1);
        end
    end

end