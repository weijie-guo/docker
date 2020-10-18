
### Single-cell analysis pipeline in R
## Installed tools: Seurat, Monocle3, scater, scImpute, velocyto, scanpy, sleepwalk, liger, RCA, scBio, SCENIC, singleCellHaystack, scmap, scran, slingshot
FROM weijie007/u20.r4.03

LABEL maintainer="weijie"

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    libgdal-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN wget -qO- "https://yihui.name/gh/tinytex/tools/install-unx.sh" | \
    sh -s - --admin --no-path \
    && mv ~/.TinyTeX /opt/TinyTeX \
    && /opt/TinyTeX/bin/*/tlmgr path add
    
RUN mkdir -p /opt/pandoc \
    && wget -O /opt/pandoc/pandoc.gz https://files.r-hub.io/pandoc/linux-64/pandoc.gz \
    && gzip -d /opt/pandoc/pandoc.gz \
    && chmod +x /opt/pandoc/pandoc \
    && ln -s /opt/pandoc/pandoc /usr/bin/pandoc \
    && wget -O /opt/pandoc/pandoc-citeproc.gz https://files.r-hub.io/pandoc/linux-64/pandoc-citeproc.gz \
    && gzip -d /opt/pandoc/pandoc-citeproc.gz \
    && chmod +x /opt/pandoc/pandoc-citeproc \
    && ln -s /opt/pandoc/pandoc-citeproc /usr/bin/pandoc-citeproc
## install umap-learn
RUN conda install -c conda-forge umap-learn -y

RUN git clone https://github.com/KlugerLab/FIt-SNE.git
RUN g++ -std=c++11 -O3 FIt-SNE/src/sptree.cpp FIt-SNE/src/tsne.cpp FIt-SNE/src/nbodyfft.cpp -o bin/fast_tsne -pthread -lfftw3 -lm
## install R packages
RUN R --slave --no-restore --no-save \
    -e "BiocManager::install(c('multtest', 'S4Vectors', 'SummarizedExperiment', 'SingleCellExperiment', 'MAST', 'DESeq2', 'BiocGenerics', 'GenomicRanges', 'IRanges', 'rtracklayer', 'monocle', 'Biobase', 'limma'))"
RUN R --slave --no-restore --no-save -e "install.packages(c('VGAM', 'R.utils', 'metap', 'Rfast2'))"
RUN R --slave --no-restore --no-save -e "install.packages('hdf5r')"
RUN R --slave --no-restore --no-save -e "install.packages('Seurat')"
RUN R --slave --no-restore --no-save -e "BiocManager::install(c('multtest', 'edgeR'))" \
    && R --slave --no-restore --no-save -e "BiocManager::install(c('BiocGenerics', 'DelayedArray', 'DelayedMatrixStats', 'batchelor'))" \
    && R --slave --no-restore --no-save -e "devtools::install_github('cole-trapnell-lab/leidenbase')" \
    && R --slave --no-restore --no-save -e "devtools::install_github('cole-trapnell-lab/monocle3')"
RUN R --slave --no-restore --no-save -e "install.packages('remotes')"
RUN R --slave --no-restore --no-save -e "remotes::install_github('satijalab/seurat-wrappers')"
