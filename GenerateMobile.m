function [Mobile_data,Mobile_tag] = GenerateMobile(phylo,ltree,phen,phen_label)

    %tagtree: tree with the information of the row numbers
    %ltree: tree with the information of the branch length of the phylogeny
    
    if phylo.isleaf(1)
         %when phylogeny is unavailable, use a tree indicated by UPGMA
        [ltree,dtree,tagtree]=linkagetree_order(phen);
    else
        %generate tagtree
        [ tagtree, ltree ] = GenerateTagtree( phylo, ltree,phen,phen_label);
        
        %remove nodes without data from phylogeny
        [ltree,tagtree]=FormatTree(ltree,tagtree);
        
        %tag phenotypic data to the phylogeny
        dtree=TagDataToTree(tagtree, phen);          
    end
    
    %ancestral reconstrocution by the method of Felsenstein (1985)
    [Mobile_data, Mobile_tag, ~]=AncestralReconstruction(ltree,dtree,tagtree,0);

end

