#!/usr/bin/env nextflow

process BAM_COVERAGE {

    publishDir params.bw, mode: 'symlink'

    conda 'deeptools-env.yaml'

    input:
        tuple val(sample_name), path(bam), path(bai)

    output:
        path "${bam.baseName}.bw"

    script:
    """
    bamCoverage -b "${bam}" -o "${bam.baseName}.bw"
    """
}

// include modules
include { FASTQC } from './modules/local/fastqc/main.nf'
include { TRIMMOMATIC } from './modules/local/trimmomatic/main.nf'
include { BOWTIE_INDEX } from './modules/local/bowtie2-build/main.nf'
include { BOWTIE } from './modules/local/bowtie2/main.nf'
include { SAMTOOLS_SORT } from './modules/local/samtools-sort/main.nf'
include { SAMTOOLS_INDEX } from './modules/local/samtools-index/main.nf'


workflow {

    paired_fastq_ch = Channel.fromFilePairs("${params.reads_dir}/*.R{1,2}.fastq")
    reference_fa = Channel.fromPath(params.ref_seq)
    aligned_files = Channel.fromPath("${params.aligned_outdir}/*.bam")
    aligned_srt_files = Channel.fromPath("${params.srt_bams}/*.bam")
    bam_and_bai = paired_fastq_ch = Channel.fromFilePairs("${params.srt_bams}/*.{bam,bam.bai}", flat: true)

    FASTQC(paired_fastq_ch)
    trimmed_fq = TRIMMOMATIC(paired_fastq_ch)
    BOWTIE_INDEX(reference_fa)
    BOWTIE(trimmed_fq, params.ref_dir)
    SAMTOOLS_SORT(aligned_files)
    SAMTOOLS_INDEX(aligned_srt_files)

}