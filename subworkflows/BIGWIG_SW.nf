/*
Subworkflow for doanloading of mutiple AMR databases


*/

include { DEEPTOOLS_READCOV_NORM as DEEPTOOLS_READCOV_NORM } from '../modules/DEEPTOOLS.nf'
include { DEEPTOOLS_READCOV as DEEPTOOLS_READCOV } from '../modules/DEEPTOOLS.nf'
include { UCSC_BIGWIGMERGE as UCSC_BIGWIGMERGE } from '../modules/UCSC.nf'
include { SAMTOOLS_INDEX as SAMTOOLS_INDEX } from '../modules/SAMTOOLS.nf'
include { SAMTOOLS_STATS as SAMTOOLS_STATS } from '../modules/SAMTOOLS.nf'
include { UCSC_BIGWIGINFO as UCSC_BIGWIGINFO } from '../modules/UCSC.nf'
include { STAR as STAR } from '../modules/STAR.nf'
include { SAMTOOLS_SAM2BAM as SAMTOOLS_SAM2BAM } from '../modules/SAMTOOLS.nf'
include { SAMTOOLS_BAMSORT as SAMTOOLS_BAMSORT } from '../modules/SAMTOOLS.nf'
include { UCSC_GET_SIZE as UCSC_GET_SIZE } from '../modules/UCSC.nf'
include { UCSC_BED2BIGWIG as UCSC_BED2BIGWIG } from '../modules/UCSC.nf'
include { SAMTOOLS_MERGE as SAMTOOLS_MERGE } from '../modules/SAMTOOLS.nf'
include { HISAT2 as HISAT2 } from '../modules/HISAT2.nf'

workflow BIGWIG_SW {
    
    take:
        ch_fastqs                // channel: [val(sample), [fastq_1, fastq_2]]
        ch_hostgen                  // channel: [val(sample), fasta]

    main:
        ch_for_align = ch_fastqs.join(ch_hostgen)

        if (params.aligner == 'star') {
            STAR(ch_for_align)
            ch_aligned = STAR.out.sam
        } else if (params.aligner == 'hisat2') {
            HISAT2(ch_for_align)
            ch_aligned = HISAT2.out.sam
        } else {
            error "Invalid aligner: ${params.aligner}. Supported aligners are 'star' and 'hisat2'."
        }

        STAR(ch_for_star)

        SAMTOOLS_SAM2BAM(STAR.out.sam)

        SAMTOOLS_BAMSORT(SAMTOOLS_SAM2BAM.out.bam)

        SAMTOOLS_STATS(SAMTOOLS_BAMSORT.out.sort)

        SAMTOOLS_INDEX(SAMTOOLS_BAMSORT.out.sort)

        DEEPTOOLS_READCOV(SAMTOOLS_INDEX.out.index)

        DEEPTOOLS_READCOV_NORM(SAMTOOLS_INDEX.out.index)

        UCSC_BIGWIGINFO(DEEPTOOLS_READCOV.out.bw)

        UCSC_BIGWIGMERGE(DEEPTOOLS_READCOV.out.bw.collect())

        UCSC_GET_SIZE(ch_hostgen.first())

        UCSC_BED2BIGWIG(UCSC_BIGWIGMERGE.out.bed, UCSC_GET_SIZE.out.sizes)

        SAMTOOLS_MERGE(SAMTOOLS_BAMSORT.out.sort.collect())
}