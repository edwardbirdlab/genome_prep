process UCSC_BIGWIGMERGE {
    label 'midmem'
    container 'ebird013/ucsc_amd64:1.0'

    input:
        file(wigs)
    output:
        path("${params.project_name}_merged.bw"), emit: bw

    script:

    """
    bigWigMerge *.bw ${params.project_name}_merged.bw
    """
}