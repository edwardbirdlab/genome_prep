/*
Subworkflow for doanloading of mutiple AMR databases


*/

include { DEEPTOOLS_READCOV_NORM as DEEPTOOLS_READCOV_NORM } from '../modules/DEEPTOOLS.nf'
include { DEEPTOOLS_READCOV as DEEPTOOLS_READCOV } from '../modules/DEEPTOOLS.nf'
include { UCSC_BIGWIGMERGE as UCSC_BIGWIGMERGE } from '../modules/UCSC.nf'


workflow BIGWIG_SW {
    
    take:
        bams            //    channel: [ val(sample), path("somthing_1.bam")]


    main:

        DEEPTOOLS_READCOV(bams)

        DEEPTOOLS_READCOV_NORM(bams)

        UCSC_BIGWIGMERGE(DEEPTOOLS_READCOV.out.bw.collect())


}