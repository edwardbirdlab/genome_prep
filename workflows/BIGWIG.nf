/*
~~~~~~~~~~~~~~~~~~~~~~
Importing subworkflows
~~~~~~~~~~~~~~~~~~~~~~
*/

include { BIGWIG_SW as BIGWIG_SW } from '../subworkflows/BIGWIG_SW.nf'


workflow BIGWIG {
    take:
        bams      //    channel: [val(sample), path(*.bam)]

    main:
        BIGWIG_SW(bams)

}