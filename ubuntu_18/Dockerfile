FROM ubuntu:18.04

LABEL maintainer="weijie"

USER root

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    apt-transport-https \
    apt-utils \
    build-essential \
    cmake \
    software-properties-common \
    curl \
    fontconfig \
    libhdf5-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libpng-dev \
    libudunits2-dev \
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

#Install Miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -P /tmp \
    && sh /tmp/Miniconda3-latest-Linux-x86_64.sh -b -p /usr/local/Miniconda3
ENV PATH=/usr/local/Miniconda3/bin:/usr/bin:$PATH
RUN conda update -y conda
#Adding conda channels
RUN conda config --add channels defaults \
    && conda config --add channels bioconda \
    && conda config --add channels conda-forge
## Configure default locale, see https://github.com/rocker-org/rocker/issues/19
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
	&& locale-gen en_US.utf8 \
	&& /usr/sbin/update-locale LANG=en_US.UTF-8

# ENV LANG=C.UTF-8
# ENV TZ=UTC
ARG R_VERSION=4.0.2
ARG OS_IDENTIFIER=ubuntu-1804

RUN wget https://cdn.rstudio.com/r/${OS_IDENTIFIER}/pkgs/r-${R_VERSION}_1_amd64.deb \
    && apt-get update -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get install -f -y ./r-${R_VERSION}_1_amd64.deb \
    && ln -s /opt/R/${R_VERSION}/bin/R /usr/bin/R \
    && ln -s /opt/R/${R_VERSION}/bin/Rscript /usr/bin/Rscript \
    && ln -s /opt/R/${R_VERSION}/lib/R /usr/lib/R \
    && rm r-${R_VERSION}_1_amd64.deb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
    
RUN echo "options(repos = 'https://cloud.r-project.org')" > $(R --slave --no-restore --no-save -e "cat(Sys.getenv('R_HOME'))")/etc/Rprofile.site

RUN R --slave --no-restore --no-save -e "install.packages(c('devtools','BiocManager','data.table', 'tidyverse'))"