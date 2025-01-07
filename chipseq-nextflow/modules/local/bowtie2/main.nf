#!/usr/bin/env nextflow

/*
* process to run bowtie alignment
*/

process BOWTIE {

    publishDir params.aligned_outdir, mode: 'symlink'

    conda 'bioconda::bowtie2'

    input:
        tuple val(sample_id), path(reads1), path(reads2)
        path(index_files_dir)

    output:
        tuple val(sample_id), file("*.sam")

    script:
    """
    bowtie2 -x "${index_files_dir}/GRCm38" -1 ${reads1} -2 ${reads2} -S ${sample_id}.sam 
    """

}