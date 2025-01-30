process DEEPTOOLS_READCOV_NORM {
    label 'midmem'
    container 'quay.io/biocontainers/deeptools:3.5.5--pyhdfd78af_0'

    input:
        tuple val(sample), file(bam), path(index)
    output:
        tuple val(sample), path("${sample}_normalized.bw"), emit: bw
        path("versions.yml"), emit: versions

    script:

    def dt_norm = params.deeptools_norm_method? "--normalizeUsing ${params.deeptools_norm_method}" : ""

    """
    bamCoverage -b ${bam} -o ${sample}.bw \\
    $dt_norm

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        Deeptools: \$(deeptools --version 2>&1 | grep "deeptools" | sed -e "s/deeptools //g")
    END_VERSIONS 
    """
}

process DEEPTOOLS_READCOV {
    label 'midmem'
    container 'quay.io/biocontainers/deeptools:3.5.5--pyhdfd78af_0'

    input:
        tuple val(sample), file(bam), path(index)
    output:
        tuple val(sample), path("${sample}.bw"), emit: bw
        path("versions.yml"), emit: versions

    script:

    """
    bamCoverage -b ${bam} -o ${sample}.bw

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        Deeptools: \$(deeptools --version 2>&1 | grep "deeptools" | sed -e "s/deeptools //g")
    END_VERSIONS 
    """
}