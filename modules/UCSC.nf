process UCSC_BIGWIGMERGE {
    label 'verylow'
    container 'ebird013/ucsc:1.0_amd64'

    input:
        file(wigs)
    output:
        path("${params.project_name}_merged.gedgraph"), emit: bed

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

process UCSC_GET_SIZE {
    label 'verylow'
    container 'ebird013/ucsc:1.0_amd64'

    input:
        file(fasta)
    output:
        path("${params.project_name}_chrom.sizes"), emit: sizes

    script:

    """
    faSize -detailed -tab ${fasta} > ${params.project_name}_chrom.sizes
    """
}

process UCSC_BED2BIGWIG {
    label 'verylow'
    container 'ebird013/ucsc:1.0_amd64'

    input:
        file(bed)
        file(sizes)
    output:
        path("${params.project_name}_merged.bw"), emit: bw

    script:

    """
    bedGraphToBigWig ${bed} ${sizes} ${params.project_name}_merged.bw
    """
}