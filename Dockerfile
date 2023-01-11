# Pull base image
FROM ubuntu:18.04

# Install required packages
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    wget \
    unzip \
    curl \
    r-base \
    r-base-dev

# Install additional R packages
RUN Rscript -e 'install.packages(c("DESeq2","rmarkdown"), repos="https://cran.r-project.org")'

# Install bioinformatics tools
RUN wget https://github.com/alexdobin/STAR/archive/2.7.5a.tar.gz && \
    tar -xzf 2.7.5a.tar.gz && \
    cd STAR-2.7.5a && \
    make STAR

RUN wget https://github.com/cole-trapnell-lab/cufflinks/releases/download/v2.2.1/cufflinks-2.2.1.Linux_x86_64.tar.gz && \
    tar -xzf cufflinks-2.2.1.Linux_x86_64.tar.gz && \
    cd cufflinks-2.2.1.Linux_x86_64 && \
    chmod +x cufflinks

RUN wget https://sourceforge.net/projects/cpat/files/latest/download -O cpat.tar.gz && \
    tar -xzf cpat.tar.gz && \
    cd cpat-1.2.3 && \
    make

RUN wget https://github.com/pachterlab/kallisto/releases/download/v0.46.1/kallisto_linux-v0.46.1.tar.gz && \
    tar -xzf kallisto_linux-v0.46.1.tar.gz

RUN wget https://github.com/s-andrews/FastQC/releases/download/v0.11.9/fastqc_v0.11.9.zip && \
    unzip fastqc_v0.11.9.zip 

# Add executables to PATH
ENV PATH /STAR-2.7.5a/bin:$PATH
ENV PATH /cufflinks-2.2.1.Linux_x86_64:$PATH
ENV PATH /cpat-1.2.3:$PATH
ENV PATH /kallisto_linux-v0.46.1:$PATH
ENV PATH /FastQC:$PATH

