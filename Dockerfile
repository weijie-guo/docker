### Single-cell analysis pipeline in R
## Installed tools: Seurat, Monocle3, scater, scImpute, velocyto, scanpy, sleepwalk, liger, RCA, scBio, SCENIC, singleCellHaystack, scmap, scran, slingshot
FROM ubuntu:bionic

LABEL maintainer ""

USER root
ENV LANG=C.UTF-8
ENV TZ=UTC
ARG R_VERSION=4.0.2
ARG OS_IDENTIFIER=ubuntu-1804

RUN apt-get update && apt-get install -y \
    apt-transport-https \
    curl \
    fontconfig \
    libhdf5-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libpng-dev \
    libboost-all-dev \
    libxml2-dev \
    openjdk-8-jdk \
    python3-dev \
    python3-pip \
    wget \
    git \
    libfftw3-dev \
    libgsl-dev \
    locales \
    perl \
    sudo \
    tzdata \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN wget -qO- "https://yihui.name/gh/tinytex/tools/install-unx.sh" | \
    sh -s - --admin --no-path \
    && mv ~/.TinyTeX /opt/TinyTeX \
    && /opt/TinyTeX/bin/*/tlmgr path add
    
RUN mkdir -p /opt/pandoc 
    && wget -O /opt/pandoc/pandoc.gz https://files.r-hub.io/pandoc/linux-64/pandoc.gz \
    && gzip -d /opt/pandoc/pandoc.gz \
    && chmod +x /opt/pandoc/pandoc \
    && ln -s /opt/pandoc/pandoc /usr/bin/pandoc \
    && wget -O /opt/pandoc/pandoc-citeproc.gz https://files.r-hub.io/pandoc/linux-64/pandoc-citeproc.gz \
    && gzip -d /opt/pandoc/pandoc-citeproc.gz \
    && chmod +x /opt/pandoc/pandoc-citeproc \
    && ln -s /opt/pandoc/pandoc-citeproc /usr/bin/pandoc-citeproc

RUN pip3 install umap-learn

RUN git clone --branch v1.1.0 https://github.com/KlugerLab/FIt-SNE.git
RUN g++ -std=c++11 -O3 FIt-SNE/src/sptree.cpp FIt-SNE/src/tsne.cpp FIt-SNE/src/nbodyfft.cpp -o bin/fast_tsne -pthread -lfftw3 -lm

RUN wget https://cdn.rstudio.com/r/${OS_IDENTIFIER}/pkgs/r-${R_VERSION}_1_amd64.deb \
    && apt-get update -qq 
    && DEBIAN_FRONTEND=noninteractive apt-get install -f -y ./r-${R_VERSION}_1_amd64.deb \
    && ln -s /opt/R/${R_VERSION}/bin/R /usr/bin/R \
    && ln -s /opt/R/${R_VERSION}/bin/Rscript /usr/bin/Rscript \
    && ln -s /opt/R/${R_VERSION}/lib/R /usr/lib/R \
    && rm r-${R_VERSION}_1_amd64.deb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
    
RUN echo "options(repos = 'https://cloud.r-project.org')" > $(R --slave --no-restore --no-save -e "cat(Sys.getenv('R_HOME'))")/etc/Rprofile.site

RUN R --slave --no-restore --no-save -e "install.packages(c('devtools','BiocManager','data.table', 'tidyverse'))"
RUN R --slave --no-restore --no-save \
    -e "BiocManager::install(c('multtest', 'S4Vectors', 'SummarizedExperiment', 'SingleCellExperiment', 'MAST', 'DESeq2', 'BiocGenerics', 'GenomicRanges', 'IRanges', 'rtracklayer', 'monocle', 'Biobase', 'limma'))"
RUN R --slave --no-restore --no-save -e "install.packages(c('VGAM', 'R.utils', 'metap', 'Rfast2'))"
RUN R --slave --no-restore --no-save -e "install.packages('hdf5r')"
RUN R --slave --no-restore --no-save -e "install.packages('Seurat')"
RUN R --slave --no-restore --no-save -e "BiocManager::install(c('multtest', 'edgeR'))" \
    && R --slave --no-restore --no-save -e "BiocManager::install(c('BiocGenerics', 'DelayedArray', 'DelayedMatrixStats', 'batchelor'))" \
    && R --slave --no-restore --no-save -e "devtools::install_github('cole-trapnell-lab/leidenbase')" \
    && R --slave --no-restore --no-save -e "devtools::install_github('cole-trapnell-lab/monocle3')"
