function [ data ] = FlipNodes(dataTree, dataTree_original ,tagTree)
%calculate randomized trait values recursively

   if dataTree.isleaf(1)
        %return the value of the node if the node is the leaf node
        data=[tagTree.get(1),dataTree.get(1)];
        return
    else
        children=dataTree.getchildren(1);
        
        %generate matrix of random variables (delta) that take value of 1 or -1 with equal probability   
        delta=randi(2,size(dataTree.get(1)));
        delta(delta==2)=-1;
        delta(delta==1)=1;
        
        %calculate phenotyhpic distance between the parent node and its
        %child nodes
        phenotypic_distance_c1=dataTree_original.get(children(1))-dataTree_original.get(1);
        phenotypic_distance_c2=dataTree_original.get(children(2))-dataTree_original.get(1);
        
        %calculate the randomized value of the parent node
        dataTree=dataTree.set(children(1),dataTree.get(1)+(delta).*phenotypic_distance_c1);
        dataTree=dataTree.set(children(2),dataTree.get(1)+(delta).*phenotypic_distance_c2);
        
        %calculate the randomized values of the child nodes recursively
        childData1=FlipNodes(dataTree.subtree(children(1)),dataTree_original.subtree(children(1)),tagTree.subtree(children(1)));
        childData2=FlipNodes(dataTree.subtree(children(2)),dataTree_original.subtree(children(2)),tagTree.subtree(children(2)));
        data=vertcat(childData1,childData2);        
        
    end
    
end

