# Flipping t-ratio test

The flipping t-ratio test is a method to assess the Pareto theory reliably with the consideration of phylogenetic signals and the arch effect.

## Overview
Recently, an economics-originated theory, the Pareto theory, has gained popularity in evolutionary biology. This theory predicts that phenotypes under natural selection fall within a polytope in phenotype space.  
To statistically assess whether given phenotype datasets fit the Pareto theory, the t-ratio test has been widely used. However, the t-ratio test suffers a serious defect because of shared phylogenetic histories and the arch effect of PCA.  
The flipping t-ratio is an improved version of the t-ratio test, which was developed to ameliorate the problems of the "naive" t-ratio test.  
The SDVMM method is used to estimate archetypes.

## Requirements
- [Matlab](https://jp.mathworks.com/products/matlab.html)
- [ParTI](https://www.weizmann.ac.il/mcb/UriAlon/download/ParTI)
- [@tree](https://tinevez.github.io/matlab-tree/)

## Usage
- To conduct flipping t-ratio test, use the function tRatioTest.


````
    [pValue, tRatio] = tRatioTest(NArchetypes, phenFile, nRan, phyloFile, method)
````

## Arguments

|Arguments           |Description                                                                                                        |
|:------------------:|:------------------------------------------------------------------------------------------------------------------|
|<em>NArchetypes</em>|The number of archetypes [<em>int</em>]                                                                            |
|<em>phenFile</em>   |File name of a phenotypic dataset [<em>character vector</em> or <em>string scalar</em>]                            |
|<em>nRan</em>       |The number of randomizations in t-ratio test [<em>int</em>]                                                        |
|<em>phyloFile</em>  |File name of a phylogenetic tree (newick format) [<em>character vector</em> or <em>string scalar</em>]             |
|<em>method</em>     |An optional argument that choses algorithm of randomization. Default: 1 (flipping t-ratio test) [<em>int</em>, 1-4]|

### <em>phenFile</em>
- A csv file that has the column header and the row header is required.
- Every trait must be continuous.
- An example:
|OTUs | Trait 1 | Trait 2 | ... | Trait K |
|:---:|:-------:|:-------:|:---:|:-------:|
|OTU 1| 0.01    | 0.02    | ... | 0.01    |
|OTU 2| 0.04    | 0.02    | ... | 0.05    |
| ... |   ...   |   ...   | ... |   ...   |
|OTU N| 0.04    | 0.02    | ... | 0.05    |
- Make sure that the labels of the row header match the labels of <em>phyloFile</em>.
- Labels of the column header do not affect results.

### <em>phyloFile</em>
- An optional argument to use phylogenetic tree.
- A rooted phylogenetic tree with branch lengths in newick format is required.
- The input phylogenetic tree does not need to be a binary tree without polytomies.
- Make sure that the labels of the OTU match the labels of <em>phenFile</em>.
- If omitted, a tree reconstructed by applying UPGMA to the trait values are used.

### <em>method</em>
- An optional argument to chose algorithms of randomization
- 1: flipping t-ratio test (default)
- 2: t-ratio test with flipping randomization
- 3: t-ratio test with improved PCA timing
- 4: naive t-ratio test

## Output

### <em>pValue</em>
- p value calculated by the chosen method.

### <em>tRatio</em>
- t-ratio of the original dataset.

## Example
- An example in a synthetic dataset is shown here.
````
  NArchetypes=3;
  phenFile='Example\SyntheticExample.csv';
  nRan=1000;
  phyloFile='Example\SyntheticExample.nwk';
  [pValue,tRatio]=tRatioTest(NArchetypes,phenFile,nRan,phyloFile);
````
