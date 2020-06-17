function [ ltree_new,dtree_new ] = FormatTree( ltree,dtree )
%   iteratively removing nodes without data from the phylogeny

    children=ltree.getchildren(1);
    
    %return if the node is the leaf node
    if size(children,2)==0
        ltree_new=ltree;
        dtree_new=dtree;
        return
    end
    
    ltree_new=tree(ltree.get(1));
    dtree_new=tree(dtree.get(1));

    count_unempty_nodes=0;
    for i=1:size(children,2)
        [ltree_child_formatted,dtree_child_formatted]=FormatTree(ltree.subtree(children(i)),dtree.subtree(children(i)));
     
        if isempty(get(dtree_child_formatted,1))==0
            count_unempty_nodes=count_unempty_nodes+1;
            ltree_new=ltree_new.graft(1,ltree_child_formatted);
            dtree_new=dtree_new.graft(1,dtree_child_formatted);
        end
    end
    
    if  count_unempty_nodes==0
        ltree_new=tree;
        dtree_new=tree;
        return
    elseif count_unempty_nodes==1
        ltree_new=ltree_new.set(1,ltree_new.get(1)+ltree_new.get(children(1)));
        dtree_new=dtree_new.set(1,dtree_new.get(children(1)));
        ltree_new=ltree_new.removenode(children(1));
        dtree_new=dtree_new.removenode(children(1));
            return
    else
        dtree_new=dtree_new.set(1,0);
        return
    end

end

