function [ output ] = NewickToTree( newick )
%convert text of newick format to tree
    sp_num=strfind(newick, ')');
    
    
    if isempty(sp_num)
        output=tree(newick);
    
    else
    last_sp=sp_num(numel(sp_num));
    
    output=tree(newick(last_sp+1:numel(newick)));
    
            
    chiNewicks=newick(2:last_sp-1);
    
    %find appropriate delimiter
    countpairs=0;
    delimiter=int32.empty;
    for i=1:numel(chiNewicks)
        if chiNewicks(i)=='('
            countpairs=countpairs+1;
        elseif chiNewicks(i)==')'
            countpairs=countpairs-1;
        elseif chiNewicks(i)==',' && countpairs==0
            delimiter=[delimiter i];
        end
    end
    
    %add child trees
    fromN=1;
    
    for i=1:numel(delimiter)+1
        if i>numel(delimiter)
            child=NewickToTree(chiNewicks(fromN:numel(chiNewicks)));
        else
            child=NewickToTree(chiNewicks(fromN:delimiter(i)-1));
            fromN=delimiter(i)+1;
        end
        output=output.graft(1,child);

    end
    
    end
    
end

