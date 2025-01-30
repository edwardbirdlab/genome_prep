process SAMTOOLS_INDEX {
    label 'verylow'
    container 'ebird013/samtools:1.17'

    input:
        tuple val(sample), file(alignment)
    output:
        tuple val(sample), path("${alignment}), path("${alignment}.bai"), emit: index

    script:

    """
    samtools index ${alignment}
    """
}