/*
~~~~~~~~~~~~~~~~~~~~~~
Importing subworkflows
~~~~~~~~~~~~~~~~~~~~~~
*/

include { BIGWIG_SW as BIGWIG_SW } from '../subworkflows/BIGWIG_SW.nf'


workflow BIGWIG {
    take:
        ch_fastqs                // channel: [val(sample), [fastq_1, fastq_2]]
        ch_hostgen                  // channel: [val(sample), fasta]

    main:
        BIGWIG_SW(ch_fastqs, ch_hostgen)

}