function [ list ] = data_with_phylo( name_tree, phen_label )
%select data points with phylogenetic information

    list=false(size(phen_label,1),1);

    for phen_num=1:size(phen_label,1)

        if isempty(find(strcmp(name_tree,char(phen_label(phen_num))), 1))==0
            list(phen_num)=true;
        end
     
    end  

end

