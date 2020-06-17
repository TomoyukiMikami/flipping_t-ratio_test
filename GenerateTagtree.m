function [ dtree_new, ltree_new ] = GenerateTagtree( dtree, ltree,phen,phen_label)
%generate tagtree

    if dtree.isleaf(1)
        
            leaf_data=dtree.get(1);
            
            
            leaf_num=transpose(1:size(phen,1));
            
            leaf_num=leaf_num(strcmp(leaf_data,cellstr(phen_label)),:);
            phen_of_this_leaf=phen( strcmp(leaf_data,cellstr(phen_label)),:);
            
            if size(phen_of_this_leaf,1)==1
                dtree_new=dtree.set(1,leaf_num(1));
                ltree_new=ltree;
            elseif size(phen_of_this_leaf,1)==0
                % return empty tree when species in phylogeny was not found in
                % the phen data
                dtree_new=tree;
                ltree_new=tree;
            else
                [ length,~,ind_tree ] = linkagetree(phen_of_this_leaf);
              
                %change leaf index
                it_ind=ind_tree.depthfirstiterator;
                for k=it_ind
                    length=length.set(k,0);
                    if ind_tree.isleaf(k)
                        leaf_data=ind_tree.get(k);
                        ind_tree=ind_tree.set(k,leaf_num(leaf_data));
                    end
                end
                children=ind_tree.getchildren(1);
                dtree_new=tree(dtree.get(1));
                ltree_new=tree(ltree.get(1));
                for l=1:size(children,2)
                    dtree_new=dtree_new.graft(1,ind_tree.subtree(children(l)));
                    ltree_new=ltree_new.graft(1,length.subtree(children(l)));
                end
            end
    else
        children=dtree.getchildren(1);
        dtree_new=tree;
        ltree_new=tree(ltree.get(1));
        for num_child=1:size(children,2)
            [ dtree_child, ltree_child ] = GenerateTagtree( dtree.subtree(children(num_child)), ltree.subtree(children(num_child)),phen,phen_label);
            dtree_new=dtree_new.graft(1,dtree_child);
            ltree_new=ltree_new.graft(1,ltree_child);
        end
    end

end

