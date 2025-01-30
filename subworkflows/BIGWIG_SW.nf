/*
Subworkflow for doanloading of mutiple AMR databases


*/

include { DEEPTOOLS_READCOV_NORM as DEEPTOOLS_READCOV_NORM } from '../modules/DEEPTOOLS.nf'
include { DEEPTOOLS_READCOV as DEEPTOOLS_READCOV } from '../modules/DEEPTOOLS.nf'
include { UCSC_BIGWIGMERGE as UCSC_BIGWIGMERGE } from '../modules/UCSC.nf'
include { SAMTOOLS_INDEX as SAMTOOLS_INDEX } from '../modules/SAMTOOLS.nf'
include { SAMTOOLS_STATS as SAMTOOLS_STATS } from '../modules/SAMTOOLS.nf'


workflow BIGWIG_SW {
    
    take:
        bams            //    channel: [ val(sample), path("somthing_1.bam")]


    main:
        SAMTOOLS_STATS(bams)

        SAMTOOLS_INDEX(bams)

        DEEPTOOLS_READCOV(SAMTOOLS_INDEX.out.index)

        DEEPTOOLS_READCOV_NORM(SAMTOOLS_INDEX.out.index)

        UCSC_BIGWIGMERGE(DEEPTOOLS_READCOV.out.bw.collect())


}