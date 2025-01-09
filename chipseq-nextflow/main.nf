#!/usr/bin/env nextflow

process MACS2 {

    publishDir params.peaks, mode: 'copy'

    conda 'macs2-env.yaml'

    input:
        path trt_bam
        path ctrl_bam

    output:
        path "${trt_bam.baseName}.*"

    script:
    """
    macs2 callpeak -t "${trt_bam}" -c "${ctrl_bam}" --broad --qvalue 1e-5 -g mm -n "${trt_bam.baseName}"
    """

}

// include modules
include { FASTQC } from './modules/local/fastqc/main.nf'
include { TRIMMOMATIC } from './modules/local/trimmomatic/main.nf'
include { BOWTIE_INDEX } from './modules/local/bowtie2-build/main.nf'
include { BOWTIE } from './modules/local/bowtie2/main.nf'
include { SAMTOOLS_SORT } from './modules/local/samtools-sort/main.nf'
include { SAMTOOLS_INDEX } from './modules/local/samtools-index/main.nf'
include { BAM_COVERAGE } from './modules/local/bam-coverage/main.nf'


workflow {

    paired_fastq_ch = Channel.fromFilePairs("${params.reads_dir}/*.R{1,2}.fastq")
    reference_fa = Channel.fromPath(params.ref_seq)

    FASTQC(paired_fastq_ch)
    trimmed_fq = TRIMMOMATIC(paired_fastq_ch)
    // BOWTIE_INDEX(reference_fa)
    BOWTIE(trimmed_fq, params.ref_dir)

    aligned_files = Channel.fromPath("${params.aligned_outdir}/*.bam")

    SAMTOOLS_SORT(aligned_files)

    aligned_srt_files = Channel.fromPath("${params.srt_bams}/*.bam")

    SAMTOOLS_INDEX(aligned_srt_files)

    bai_files = Channel.fromPath("${params.srt_bams}/*.bai")

    control_file = Channel.value("${params.ctrl_bam}")

    //BAM_COVERAGE(aligned_srt_files, bai_files)

    //MACS2(aligned_srt_files, control_file)

    

}