#!/usr/bin/env nextflow

/*
* process to run samtools sort
*/


process SAMTOOLS_SORT {

    publishDir params.srt_bams, mode: 'symlink'

    conda 'bioconda::samtools'

    input:
        path bam

    output:
        path "${bam.baseName}.sorted.bam"

    script:
    """
    samtools sort "${bam}" "${bam.baseName}.sorted"
    """

}