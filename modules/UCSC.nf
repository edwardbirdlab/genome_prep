process UCSC_BIGWIGMERGE {
    label 'midmem'
    container 'ebird013/ucsc:1.0_amd64'

    input:
        file(wigs)
    output:
        path("${params.project_name}_merged.bw"), emit: bw

    script:

    """
    bigWigMerge *.bw ${params.project_name}_merged.bw
    """
}