#!/usr/bin/env nextflow

// include modules
include { FASTQC } from './modules/local/fastqc/main.nf'
include { TRIMMOMATIC } from './modules/local/trimmomatic/main.nf'
include { BOWTIE_INDEX } from './modules/local/bowtie2-build/main.nf'
include { BOWTIE } from './modules/local/bowtie2/main.nf'
include { SAMTOOLS_SORT } from './modules/local/samtools-sort/main.nf'


workflow {
    paired_fastq_ch = Channel.fromFilePairs("${params.reads_dir}/*.R{1,2}.fastq")
    reference_fa = Channel.fromPath(params.ref_seq)
    aligned_files = Channel.fromPath("${params.aligned_outdir}/*.bam")

    FASTQC(paired_fastq_ch)
    trimmed_fq = TRIMMOMATIC(paired_fastq_ch)
    BOWTIE_INDEX(reference_fa)
    BOWTIE(trimmed_fq, params.ref_dir)
    SAMTOOLS_SORT(aligned_files)

}