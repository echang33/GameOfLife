function [out] = RLE_decoder(file)
%Takes in RLE file, outputs as matrix of 0s and 1s

%import file
in = importdata(file);
rows = size(in,1);

%Loops through each row of the RLE file, ignores comments, name, and other
%headers beginning with '#'
rle_string = '';
for i=1:1:rows
    if in{i}(1) ~= '#'
        % Get the dimensions of the output matrix as stated in header
        if in{i}(1) == 'x'
            [~,a] = regexp(in(i),'x\s.\s\d+');
            col = in{i}(5:a{1});
            [~,b] = regexp(in(i),'y\s.\s\d+');
            row = in{i}(a{1}+7:b{1});
            out = zeros(str2num(row),str2num(col));
        % remaining row contains the RLE encoded matrix
        else 
            rle_string = strcat(rle_string, in(i));
        end
end

end
    % separate each row of the matrix in new cell array
    
    str = rle_string{1};
    encoded = regexp(str,'\d*\w*[\$,!]','match'); 
    
% parse through each row
for j = 1:1:size(encoded,2)
startindex = regexp(encoded{j},'[b,o]');
count = 1;

    % each time a number of dead/alive cells is specified, find
    % the number of times it is iterated
    for s = 1:1:size(startindex,2)
        % special case for 1st index, as index 0 DNE
        if s == 1
            % if the string starts with a letter
            if startindex(s) == 1 
                 alength = '1';
            else
                % get number before it, as a char
                 alength = encoded{j}(1:startindex(s)-1);
            end
        else
            % if string starts with letter
            if ~isstrprop(encoded{j}(startindex(s)-1),"digit") 
                alength = '1';
            else
                alength = encoded{j}(startindex(s-1)+1:startindex(s)-1);
            end
        end
        % convert char to int, add values to output array
        % accordingly
        length = str2num(alength);
        if encoded{j}(startindex(s)) == 'b'
            out(j, count:length+count-1) = 0;
        else
            out(j, count:length+count-1) = 1;
        end
        % keeps count of the index (column)
        count = count + length;
    end
end
end