function [ Newick ] = TreeToNewick( DataTree,LengthTree )
%convert phylogenetic tree to newick format
%this function only supports binary tree
    if DataTree.isleaf(1)
        Newick=DataTree.get(1);
        if isfloat(Newick)
            Newick=num2str(Newick);
        end
        return
    end
    children=DataTree.getchildren(1);
    
    Newick='(';
    for i=1:size(children,2)
        childNewick=TreeToNewick(DataTree.subtree(children(i)),LengthTree.subtree(children(i)));
        Newick=strcat(Newick,childNewick);
        Newick=strcat(Newick,':',num2str(LengthTree.get(children(i))));
        if i~=size(children,2)
            Newick=strcat(Newick,',');
        end
    end
    Newick=strcat(Newick,');');
    
end

