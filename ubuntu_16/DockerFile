FROM ubuntu:18.04

LABEL maintainer="weijie"

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
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

#Install Miniconda
RUN
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -P /tmp
    sh /tmp/Miniconda3-latest-Linux-x86_64.sh -b -p /usr/local/Miniconda3
    export PATH=/usr/local/Miniconda3/bin:/usr/bin:$PATH
    conda update -y  conda
    #Adding conda channels
    conda config --add channels defaults
    conda config --add channels bioconda
    conda config --add channels conda-forge

RUN git clone --branch v1.1.0 https://github.com/KlugerLab/FIt-SNE.git
RUN g++ -std=c++11 -O3 FIt-SNE/src/sptree.cpp FIt-SNE/src/tsne.cpp FIt-SNE/src/nbodyfft.cpp -o bin/fast_tsne -pthread -lfftw3 -lm

## Configure default locale, see https://github.com/rocker-org/rocker/issues/19
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
	&& locale-gen en_US.utf8 \
	&& /usr/sbin/update-locale LANG=en_US.UTF-8

ENV LANG=C.UTF-8
ENV TZ=UTC
ARG R_VERSION=4.0.2
ARG OS_IDENTIFIER=ubuntu-1804

## This was not needed before but we need it now
ENV DEBIAN_FRONTEND=noninteractive

RUN wget https://cdn.rstudio.com/r/${OS_IDENTIFIER}/pkgs/r-${R_VERSION}_1_amd64.deb \
    && apt-get update -qq 
    && apt-get install -f -y ./r-${R_VERSION}_1_amd64.deb \
    && ln -s /opt/R/${R_VERSION}/bin/R /usr/bin/R \
    && ln -s /opt/R/${R_VERSION}/bin/Rscript /usr/bin/Rscript \
    && ln -s /opt/R/${R_VERSION}/lib/R /usr/lib/R \
    && rm r-${R_VERSION}_1_amd64.deb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
    
RUN echo "options(repos = 'https://cloud.r-project.org')" > $(R --slave --no-restore --no-save -e "cat(Sys.getenv('R_HOME'))")/etc/Rprofile.site

RUN R --slave --no-restore --no-save -e "install.packages(c('devtools','BiocManager','data.table', 'tidyverse'))"
