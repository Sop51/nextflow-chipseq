#!/usr/bin/env nextflow

process TRIMMOMATIC{

    publishDir params.trim_outdir, mode: 'symlink'

    conda "bioconda::trimmomatic=0.39"

    input:
        tuple val(sample_id), file(reads)

    output:
        tuple val(sample_id), file("${sample_id}_R1_paired.fastq")
        file("${sample_id}_R1_unpaired.fastq")
        file("${sample_id}_R2_paired.fastq")
        file("${sample_id}_R2_unpaired.fastq")

    script:
    """
    trimmomatic PE -phred33 -threads 4 ${reads[0]} ${reads[1]} ${sample_id}_R1_paired.fastq ${sample_id}_R1_unpaired.fastq ${sample_id}_R2_paired.fastq ${sample_id}_R2_unpaired.fastq ILLUMINACLIP:"${params.adapter}":2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15
    """

}


// include modules
include { FASTQC } from './modules/local/fastqc/main.nf'


workflow{
    paired_fastq_ch = Channel.fromFilePairs("${params.reads_dir}/*.R{1,2}.fastq")
    FASTQC(paired_fastq_ch)
    TRIMMOMATIC(paired_fastq_ch)
}