function [ OutputTree,Length ] = ReadNewick( filename )
%Read Newick file from a file path
    %Read Newick String to S
    fp=fopen(filename,'rt');
    S=fread(fp);
    fclose(fp);
    S=char(S');
    
    
    OutputTree=NewickToTree(S);
       
    %get length
    iterator=OutputTree.depthfirstiterator;
    Length=tree(OutputTree,'clear');
    
    for i=iterator
        original=OutputTree.get(i);
        if ~contains(original,':')
            Length=Length.set(i,0);
        else
            splitted=strsplit(original,':');

            if numel(splitted)==1
                 Length=Length.set(i,str2double(cell2mat(splitted(1))));
            else
                OutputTree=OutputTree.set(i,char(splitted(1)));
                Length=Length.set(i,str2double(cell2mat(splitted(2))));
            end
        end
    end    
end

