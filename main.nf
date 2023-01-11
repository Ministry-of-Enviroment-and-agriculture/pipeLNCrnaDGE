# Nextflow pipeline for lncRNA sequence analysis

params.quality_control_tools = ['fastqc']
params.alignment_and_assembly_tools = ['star', 'cufflinks']
params.gene_removal_tools = ['cuffcompare', 'gffcompare']
params.coding_potential_tools = ['cpat']
params.classification_and_quantification_tools = ['kallisto']
params.differential_expression_tools = ['DESeq2']

# Quality control
process quality_control {
    input:
        file('*.fastq.gz')
    output:
        file('*.fastq.gz.fastqc.html')
    container:
        "docker://quay.io/biocontainers/fastqc:0.11.9--4"
    script:
        """
        for tool in params.quality_control_tools {
            if tool == 'fastqc' {
                fastqc -o . -t 2 $input
            }
        }
        """
}

# Alignment and assembly
process alignment_and_assembly {
    input:
        file('*.fastq.gz')
    output:
        file('*.gtf')
    container:
        "docker://quay.io/biocontainers/star:2.7.5a--hgf51111_0"
    script:
        """
        for tool in params.alignment_and_assembly_tools {
            if tool == 'star' {
                star --genomeDir /path/to/genome --readFilesIn $input --runThreadN 2 --outFileNamePrefix $input
            }
            if tool == 'cufflinks' {
                cufflinks -p 2 -o . $input
            }
        }
        """
}

# Remove known genes and exclude by criteria
process gene_removal {
    input:
        file('*.gtf')
    output:
        file('*.gtf')
    container:
        "docker://quay.io/biocontainers/cuffcompare:2.2.1--hgf51111_0"
    script:
        """
        for tool in params.gene_removal_tools {
            if tool == 'cuffcompare' {
                cuffcompare -r /path/to/reference.gtf -i $input -o .
            }
            if tool == 'gffcompare' {
                gffcompare -r /path/to/reference.gtf -i $input -o .
            }
        }
        """
}

# Protein coding potential calculation and filtering
process coding_potential {
    input:
        file('*.gtf')
    output:
        file('*.txt')
    container:
        "docker://quay.io/biocontainers/cpat:1.2.3--hgf51111_2"
    script:
        """
        for tool in params.coding_potential_tools {
            if tool == 'cpat' {
                cpat -g /path/to/genome.fa -x /path/to

                cpat -g /path/to/genome.fa -x /path/to/exon.bed -i $input -o ${input}.cpat.txt
            }
        }
        """
}

# Classification and quantification
process classification_and_quantification {
    input:
        file('*.gtf')
    output:
        file('*.txt')
    container:
        "docker://quay.io/biocontainers/kallisto:0.46.1--hgf51111_2"
    script:
        """
        for tool in params.classification_and_quantification_tools {
            if tool == 'kallisto' {
                kallisto quant -i /path/to/index.idx -o ${input}.kallisto.txt -b 100 $input
            }
        }
        """
}

# Differential expression analysis
process differential_expression {
    input:
        file('*.txt')
    output:
        file('*.txt')
    container:
        "docker://quay.io/biocontainers/deseq2:1.24.0--hgf51111_0"
    script:
        """
        for tool in params.differential_expression_tools {
            if tool == 'DESeq2' {
                Rscript -e 'library(DESeq2); counts <- read.table("$input", header=TRUE); deseq <- DESeqDataSetFromMatrix(countData = counts, colData = data.frame(condition = c("condition1","condition2")), design = ~ condition); deseq <- DESeq(deseq); results(deseq, pAdjustMethod = "BH")' -o ${input}.deseq2.txt
            }
        }
        """
}

# Summary and Report
process summary_and_report {
    input:
        file('*.txt')
    output:
        file('*.html')
    container:
        "docker://quay.io/biocontainers/rmarkdown:1.14--r3.6.2_1"
    script:
        """
        Rscript -e 'library(rmarkdown); render("/path/to/report.Rmd", output_file = "$input.html")'
        """
}
