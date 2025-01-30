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

process UCSC_BIGWIGINFO {
    label 'midmem'
    container 'ebird013/ucsc:1.0_amd64'

    input:
        tuple val(sample), file(alignment)
    output:
        tuple val(sample), path("${sample}_bigwiginfo.txt"), path("${sample}_bigwiginfo_chroms.txt"), emit: info

    script:

    """
    bigWigInfo ${alignment} > ${sample}_bigwiginfo.txt
    bigWigInfo -chroms ${alignment} > ${sample}_bigwiginfo_chroms.txt
    """
}