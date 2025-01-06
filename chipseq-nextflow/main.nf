#!/usr/bin/env nextflow

process BOWTIE_INDEX {

    conda 'bioconda::bowtie2'

    input:
        path reference_fa

    output:
        path 'bowtie_index/GRCm38*'

    script:
    """
    mkdir bowtie_index

    bowtie2-build "${reference_fa}" "bowtie_index/GRCm38"
    """

}

process BOWTIE {

    publishDir params.aligned_outdir, mode: 'symlink'

    conda 'bioconda::bowtie2'

    input:
        tuple val(sample_id), path(reads)
        path(index_files_dir)

    output:
        tuple val(sample_id), file("*.sam")

    script:
    """
    bowtie2 -X "${index_files_dir}/GRCm38" -1 ${reads[0]} -2 ${reads[1]} -S ${sample_id}.sam 
    """

}

// include modules
include { FASTQC } from './modules/local/fastqc/main.nf'
include { TRIMMOMATIC } from './modules/local/trimmomatic/main.nf'


workflow {
    paired_fastq_ch = Channel.fromFilePairs("${params.reads_dir}/*.R{1,2}.fastq")
    reference_fa = Channel.fromPath(params.ref_seq)

    FASTQC(paired_fastq_ch)

    trimmed_fq = TRIMMOMATIC(paired_fastq_ch)
    index = BOWTIE_INDEX(reference_fa)
    trimmed_fq_tuple = trimmed_fq.map { tuple -> tuple[1] }

    // pass the trimmed paired files to the BWAMEM process
    BOWTIE(trimmed_fq_tuple, index)
}