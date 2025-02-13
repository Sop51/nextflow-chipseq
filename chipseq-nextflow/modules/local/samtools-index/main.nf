#!/usr/bin/env nextflow

/* 
Process definition to index bam files
*/

process SAMTOOLS_INDEX {

    publishDir params.srt_bams, mode: 'symlink'

    conda 'bioconda::samtools'

    input:
        path bam

    output:
        path "${bam.baseName}.bai"

    script:
    """
    samtools index "${bam}" "${bam.baseName}.bai"
    """

}