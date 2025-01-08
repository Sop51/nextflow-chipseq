#!/usr/bin/env nextflow

/* 
Process definition to deep tools bam coverage
*/

process BAM_COVERAGE {

    publishDir params.bw, mode: 'symlink'

    conda 'deeptools-env.yaml'

    input:
        path bam
        path index

    output:
        path "${bam.baseName}.bw"

    script:
    """
    bamCoverage -b "${bam}" -o "${bam.baseName}.bw"
    """
}