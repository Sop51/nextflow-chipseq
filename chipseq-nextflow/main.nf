#!/usr/bin/env nextflow

// include modules
include { FASTQC } from './modules/local/fastqc/main.nf'

workflow{
    paired_fastq_ch = Channel.fromFilePairs("${params.reads_dir}/*.R{1,2}.fastq")
    FASTQC(paired_fastq_ch)
}