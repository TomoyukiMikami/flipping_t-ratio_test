function [ pValue,tRatio] = tRatioTest(NArchetypes, phen_csv,nRan,phylo_tree,method)

    if nargin<4
        phylo_tree='';
        method=1;
    elseif nargin<5
        method=1;
    end

    switch method
        case 1
            % flipping t-ratio test
            improvedPCAtiming=true;
            flipping=true;
        case 2
            % t-ratio test with flipping randomization
            improvedPCAtiming=false;
            flipping=true;
        case 3
            % t-ratio test with improved PCA timing
            improvedPCAtiming=true;
            flipping=false;
        case 4
            % naive t-ratio test
            improvedPCAtiming=false;
            flipping=false;
    end

    algNum=4;
    %reading phenotypic data
    phen = readtable(phen_csv,'ReadVariableNames',false,'HeaderLines',1);  
    phen_label=categorical(phen.Var1);
   
    if (strcmp(phylo_tree,'')==false)
        %read phylogenetic relationship
        [phylo,ltree]=ReadNewick(phylo_tree);
        %chose phenotypic data with phylogenetic relationship
        data_used=data_with_phylo(phylo,phen_label);
        phen=phen(data_used,:);
    else
        phylo=tree;
        ltree=tree;
    end
    
    phen_label=categorical(phen.Var1);
    phen(:,[1])=[];  %#ok<NBRAK>
    phen=table2array(phen);
            
    DataDim=size(phen,2);
    if improvedPCAtiming==false
        [~,phen,~,~,~,~] = pca(phen);
        phen=phen(:,1:min(NArchetypes-1,DataDim));
        PCA=false;
    else
        PCA=true;
    end


    [tRatio, archReal,PhenPCA,~]=PCA_unmixing(phen,NArchetypes, algNum, DataDim, PCA);   
    

    tRatioRand=zeros(nRan,1);
    
    if flipping==true
        %generate trees containing information on the phenothypic data (Mobile)
        [Mobile_data,Mobile_tag] = GenerateMobile(phylo,ltree,phen,phen_label);
        for m=1:nRan
            phen_rand=FlippingRandomization(Mobile_data,Mobile_tag);   
            [tRatioRand(m), ~,~,~]=PCA_unmixing(phen_rand, NArchetypes, algNum, DataDim, PCA);
        end
    else
        for m=1:nRan  
            phen_rand=zeros(size(phen));
            % permutation method
            for i=1:size(phen,2)
                shuffInd=randperm(size(phen,1)); 
                phen_rand(:,i)=phen(shuffInd,i);
            end
            [tRatioRand(m), ~,~,~]=PCA_unmixing(phen_rand,NArchetypes, algNum, DataDim, PCA);
        end
    end
        
    figure();
    histogram(tRatioRand,'FaceColor','red');
    hold on;   
       
    pValue=sum(tRatioRand>tRatio)/nRan;
    X=['tRatio Real : ',num2str(tRatio)];
    disp(X);
    X=['p value : ',num2str(pValue)];
    disp(X);
    
end

