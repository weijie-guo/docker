### Single-cell analysis pipeline in R
## Installed tools: Seurat, Monocle3, scater, scImpute, velocyto, scanpy, sleepwalk, liger, RCA, scBio, SCENIC, singleCellHaystack, scmap, scran, slingshot
## signac, BSgenome.Hsapiens.UCSC.hg19, hg38, mm10
## chromVAR for the analysis of motif accessibility in scATAC-seq
## presto for fast differential expression analyses.
## TFBSTools for TFBS analysis
## JASPAR2020 for JASPAR motif models
## GenomeInfoDb: Utilities for manipulating chromosome names, including modifying them to follow a particular naming style
FROM weijie007/seurat4

LABEL maintainer="weijie"
    
## install signac
RUN R --slave --no-restore --no-save -e "setRepositories(ind=1:2)" -e "devtools::install_github('timoast/signac', ref = 'develop')"
## Installing genome assembly and gene annotation packages
RUN R --slave --no-restore --no-save -e "BiocManager::install(c('BSgenome.Hsapiens.UCSC.hg19', 'EnsDb.Hsapiens.v75'))"
RUN R --slave --no-restore --no-save -e "BiocManager::install(c('BSgenome.Hsapiens.UCSC.hg38', 'EnsDb.Hsapiens.v86'))"
RUN R --slave --no-restore --no-save -e "BiocManager::install(c('BSgenome.Mmusculus.UCSC.mm10', 'EnsDb.Mmusculus.v79'))"
RUN R --slave --no-restore --no-save -e "remotes::install_github('immunogenomics/presto')"
RUN R --slave --no-restore --no-save -e "BiocManager::install(c('chromVAR', 'TFBSTools', 'JASPAR2020', 'motifmatchr', 'GenomeInfoDb'))"
