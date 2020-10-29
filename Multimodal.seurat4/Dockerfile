### Single-cell analysis pipeline in R
## Installed tools: Seurat, Monocle3, scater, scImpute, velocyto, scanpy, sleepwalk, liger, RCA, scBio, SCENIC, singleCellHaystack, scmap, scran, slingshot
## add 
FROM weijie007/seurat4

LABEL maintainer="weijie"
    
## install signac
RUN R --slave --no-restore --no-save -e "devtools::install_github('timoast/signac', ref = 'develop')"
## Installing genome assembly and gene annotation packages
RUN R --slave --no-restore --no-save -e "BiocManager::install(c('BSgenome.Hsapiens.UCSC.hg19', 'EnsDb.Hsapiens.v75'))"
RUN R --slave --no-restore --no-save -e "BiocManager::install(c('BSgenome.Hsapiens.UCSC.hg38', 'EnsDb.Hsapiens.v86'))"
RUN R --slave --no-restore --no-save -e "BiocManager::install(c('BSgenome.Mmusculus.UCSC.mm10', 'EnsDb.Mmusculus.v79'))"
