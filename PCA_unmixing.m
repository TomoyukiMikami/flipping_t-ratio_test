function [ tRatio, arch,PhenPCA,explained] = PCA_unmixing( phen, NArchetypes, algNum, DataDim, PCA)
    numIter=1;
    if PCA==true
        [~,PhenPCA,~,~,explained,~] = pca(phen);
    else
        PhenPCA=phen;
        explained=null(1);
    end
    
    VolConv =  ConvexHull(PhenPCA(:,1:min(NArchetypes-1,DataDim)));
    [arch,VolArch]=findMinSimplex(numIter,PhenPCA,algNum,NArchetypes);
    tRatio=VolArch./VolConv;
end

