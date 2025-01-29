#!/usr/bin/env nextflow

nextflow.enable.dsl=2




ch_bams = Channel.fromPath(params.sample_sheet) \
    | splitCsv(header:true) \
    | map { row-> tuple(row.sample, file(row.bam))}


include { BIGWIG as BIGWIG } from './workflows/BIGWIG.nf'


workflow {


    BIGWIG(ch_bams)

}