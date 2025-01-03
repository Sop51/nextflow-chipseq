#!/usr/bin/env nextflow

/*
* process to run trimmomatic
*/

process TRIMMOMATIC{

    publishDir params.trim_outdir, mode: 'symlink'

    conda "bioconda::trimmomatic=0.39"

    input:
        tuple val(sample_id), file(reads)

    output:
        tuple val(sample_id), file("*trimmed.fastq")


    script:

    """
    trimmomatic PE -phred33 -threads 4 ${reads[0]} ${reads[1]} ${sample_id}_R1_trimmed.fastq output_R1_unpaired.fastq ${sample_id}_R2_trimmed.fastq output_R2_unpaired.fastq ILLUMINACLIP:"${params.adapter}":2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15
    """
}