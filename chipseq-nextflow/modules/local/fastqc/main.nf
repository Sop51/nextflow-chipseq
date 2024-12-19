#!/usr/bin/env nextflow

/*
* process to run fastqc
*/

process FASTQC{

    conda "bioconda::fastqc"

    publishDir params.fastqc_outdir, mode: 'copy'

    input:
        tuple val(sample_id), file(reads)

    output:
        file("${sample_id}.R1_fastqc.html")
        file("${sample_id}.R2_fastqc.html")

    script:
    """
        fastqc ${reads[0]} ${reads[1]}
    """

}
