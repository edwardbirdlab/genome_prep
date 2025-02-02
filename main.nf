#!/usr/bin/env nextflow

nextflow.enable.dsl=2




ch_fastq = Channel.fromPath(params.sample_sheet) \
    | splitCsv(header:true) \
    | map { row-> tuple(row.sample, file(row.r1), file(row.r2)) }

ch_hostgen = Channel.fromPath(params.sample_sheet) \
    | splitCsv(header:true) \
    | map { row-> tuple(row.sample, file(row.refernce_genome)) }


include { BIGWIG as BIGWIG } from './workflows/BIGWIG.nf'


workflow {


    BIGWIG(ch_fastq, ch_hostgen)

}