function [ Tree ] = TagDataToTree( Tree, data )
%tag phenotypic data to the phylogeny
    iterator=Tree.depthfirstiterator;
    for i=iterator
        num_of_data=Tree.get(i);
      
        if num_of_data~=0            
            leaf_data=data(Tree.get(i),:);
            Tree=Tree.set(i,leaf_data);
        end
    end    
end

