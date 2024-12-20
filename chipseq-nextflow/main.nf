#!/usr/bin/env nextflow

process TRIMMOMATIC{

    publishDir params.trim_outdir, mode: 'symlink'

    conda "bioconda::trimmomatic"

    input:
        tuple val(sample_id), file(reads)

    output:
        tuple val(sample_id), file("${params.trim_outdir}/${sample_id}_R1_paired.fq.gz")
        file("${params.trim_outdir}/${sample_id}_R1_unpaired.fq.gz")
        file("${params.trim_outdir}/${sample_id}_R2_paired.fq.gz")
        file("${params.trim_outdir}/${sample_id}_R2_unpaired.fq.gz")

    script:
    """
    trimmomatic PE -phred33 ${reads[0]} ${reads[1]} ${params.trim_outdir} ILLUMINACLIP:"${params.adapter}":2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15
    """

}


// include modules
include { FASTQC } from './modules/local/fastqc/main.nf'


workflow{
    paired_fastq_ch = Channel.fromFilePairs("${params.reads_dir}/*.R{1,2}.fastq")
    FASTQC(paired_fastq_ch)
    TRIMMOMATIC(paired_fastq_ch)
}