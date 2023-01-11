# pipeLNCrnaDGE
## A nextflow based pipeline for Differential gene expression (DGE) analysis of lncRNAs sequences

## Following the steps in this pipeline:
1. quality control, using tools FastQC
2. Alignment and assembly, using tools STAR with Cuffinks
3. Remove known genes and exclude by criterions, using tools cuffcompare , gffcomapre
4. Protein coding potential calculation and filtering, using tool CPAT
5. Classfication and quantification, using tools kallisto
6. Differential expression analysis, using tools DESeq2
7. Summary and Report

