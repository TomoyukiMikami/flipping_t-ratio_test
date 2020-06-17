function [ dataTree, rootLength_PIC] = CalculateAncestors( lengthTree, dataTree )


    %get mobiles of children
    children=lengthTree.getchildren(1);
  
    
    if lengthTree.isleaf(children(1))
        child1_dataTree=tree(dataTree.get(children(1)));
        child1_length=lengthTree.get(children(1));
    else
        [child1_dataTree,child1_length]=CalculateAncestors(lengthTree.subtree(children(1)),dataTree.subtree(children(1)));
    end
    
    if lengthTree.isleaf(children(2))
        child2_dataTree=dataTree.subtree(children(2));
        child2_length=lengthTree.get(children(2));
    else
        [child2_dataTree,child2_length]=CalculateAncestors(lengthTree.subtree(children(2)),dataTree.subtree(children(2)));
    end
   
    
    %calculate root of the tree according to the formula by Felsenstein (1985)
    if child1_dataTree.get(1)==child2_dataTree.get(1)
        dataTree=dataTree.set(1,child1_dataTree.get(1));
    elseif (child1_length==0)&&(child2_length==0)
        dataTree=dataTree.set(1,(child1_dataTree.get(1)+child2_dataTree.get(1))/2);
    else
        dataTree=dataTree.set(1,((1/child1_length)*child1_dataTree.get(1)+(1/child2_length)*child2_dataTree.get(1))/((1/child1_length)+(1/child2_length)));
    end
    
    if (child1_length==0)&&(child2_length==0)
        rootLength_PIC=lengthTree.get(1);
    else    
        rootLength_PIC=lengthTree.get(1)+(child1_length*child2_length)/(child1_length+child2_length);
    end    
    
end