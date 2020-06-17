function [ length,dtree,ntree ] = linkagetree( data )
%generate tree using UPGMA
    Z=linkage(data, 'average','euclidean');
    Z(isnan(Z))=1;
    root=size(Z,1)*2+1;
    
    [length,ntree]=mat_to_tree(root,0,Z);
    
    %convert the content of ntree into the real data : dtree
    dtree=TagDataToTree(ntree, data);
    
end

