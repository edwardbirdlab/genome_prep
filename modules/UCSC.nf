process UCSC_BIGWIGMERGE {
    label 'verylow'
    container 'ebird013/ucsc:1.0_amd64'

    input:
        file(wigs)
    output:
        path("${params.project_name}_merged.gedgraph"), emit: bw

    script:

    """
    bigWigMerge *.bw ${params.project_name}_merged.gedgraph
    """
}
    
process UCSC_BIGWIGINFO {
    label 'verylow'
    container 'ebird013/ucsc:1.0_amd64'

    input:
        tuple val(sample), file(alignment)
    output:
        tuple val(sample), path("${sample}_bigwiginfo.txt"), emit: info

    script:

    """
    bigWigInfo -chroms ${alignment} > ${sample}_bigwiginfo.txt
    """
}