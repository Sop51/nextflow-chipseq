#!/usr/bin/env nextflow

/*
* process to run bowtie index
*/

process BOWTIE_INDEX {

    publishDir params.ref_dir, mode: 'symlink'

    conda 'bioconda::bowtie2'

    input:
        path reference_fa

    output:
        path 'GRCm38*'

    script:
    """
    bowtie2-build "${reference_fa}" GRCm38
    """

}