function [ dataTree_new,  tagTree, rootLengthChanged_by_PIC] = AncestralReconstruction( lengthTree, dataTree, tagTree, dim)
%Ancectrar leconstruction by the method of Felsenstein(1985)
    children=dataTree.getchildren(1);  

    %get the dimension of the dataset
    if dim==0
        getDimTree=dataTree;
        while getDimTree.isleaf(1)==0
        getDimTree=getDimTree.subtree(children(1));
        end
        dim=size(getDimTree.get(1),2);
    end
    
    %check if the root node is leaf
    if lengthTree.isleaf(1)
        dataTree_new=dataTree;
        %create leaf
        rootLengthChanged_by_PIC=lengthTree.get(1);
        return
    else       
        
        children_root=zeros(size(children,2),dim);
        children_dataTree=cell(1,size(children,2));
        children_tagTree=cell(1,size(children,2));
        children_rootLengthChanged_by_PIC=zeros(1,size(children,2));



        for i=1:size(children,2)
            %reconstruct ancestral states of child nodes
                [children_dataTree{i}, children_tagTree{i},children_rootLengthChanged_by_PIC(i)]=AncestralReconstruction(lengthTree.subtree(children(i)),dataTree.subtree(children(i)),tagTree.subtree(children(i)),dim);
                children_root(i,:)=children_dataTree{i}.get(1);        
        end
                
        [~,~,tagtree_linkage]=linkagetree(children_root);
        % Create dataTree & lengthTree for linkage
        dataTree_linkage=tagtree_linkage;
        lengthTree_linkage=tagtree_linkage;
        iterator=tagtree_linkage.depthfirstiterator;
        for i=iterator
           if tagtree_linkage.isleaf(i)
               dataTree_linkage=dataTree_linkage.set(i,children_root(tagtree_linkage.get(i),:));
               lengthTree_linkage=lengthTree_linkage.set(i,children_rootLengthChanged_by_PIC(tagtree_linkage.get(i)));  
               
           end
        end
        
        lengthTree_linkage=lengthTree_linkage.set(1,lengthTree.get(1));
        [ dataTree_linkage, rootLengthChanged_by_PIC] = CalculateAncestors( lengthTree_linkage, dataTree_linkage )  ;      
        
        iterator=tagtree_linkage.depthfirstiterator;
        tagTree=tagtree_linkage;        
        
        for i=iterator
            if tagTree.isleaf(i)
                n=tagtree_linkage.get(i);
                tagTree=tagTree.set(i,'#delete me#');
                tagTree=tagTree.graft(tagTree.getparent(i),children_tagTree{n});
                
                dataTree_linkage=dataTree_linkage.set(i,'#delete me#');
                dataTree_linkage=dataTree_linkage.graft(dataTree_linkage.getparent(i),children_dataTree{n});
                
            end            
        end
        
        %Delete #Delete me#
        for i=1:size(children,2)
            deleted=0;
            delete_it=tagTree.depthfirstiterator;
            num_it=1;
            while deleted==0
                if strcmp(tagTree.get(delete_it(num_it)),'#delete me#')
                    tagTree=tagTree.removenode(delete_it(num_it));
                    dataTree_linkage=dataTree_linkage.removenode(delete_it(num_it));                    
                    deleted=1;                    
                end
                num_it=num_it+1;
            end
        end
         dataTree_new=dataTree_linkage;
        
        return;
  
    end
   
end

