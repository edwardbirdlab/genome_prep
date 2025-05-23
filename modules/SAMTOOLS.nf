process SAMTOOLS_INDEX {
    label 'verylow'
    container 'ebird013/samtools:1.17'

    input:
        tuple val(sample), file(alignment)
    output:
        tuple val(sample), path("${alignment}"), path("${alignment}.bai"), emit: index
        path("versions.yml"), emit: versions

    script:

    """
    samtools index ${alignment}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        Samtools: \$(samtools --version 2>&1 | grep "samtools " | sed -e "s/samtools //g")
    END_VERSIONS 
    """
}

process SAMTOOLS_STATS {
    label 'verylow'
    container 'ebird013/samtools:1.17'

    input:
        tuple val(sample), file(alignment)
    output:
        tuple val(sample), path("${sample}_align.txt"), emit: stats
        path("versions.yml"), emit: versions

    script:

    """
    samtools stats ${alignment} > ${sample}_align.txt

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        Samtools: \$(samtools --version 2>&1 | grep "samtools " | sed -e "s/samtools //g")
    END_VERSIONS 
    """
}

process SAMTOOLS_REHEADER {
    label 'verylow'
    container 'ebird013/samtools:1.17'

    input:
        tuple val(sample), file(alignment)
    output:
        tuple val(sample), path("${sample}_fixed.bam"), emit: fix
        path("versions.yml"), emit: versions

    script:

    """
    samtools view -H ${alignment} > header.txt
    sed -i 's/SN:lcl|/SN:/' header.txt
    samtools reheader header.txt ${alignment} > ${sample}_fixed.bam

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        Samtools: \$(samtools --version 2>&1 | grep "samtools " | sed -e "s/samtools //g")
    END_VERSIONS 
    """
}

process SAMTOOLS_SAM2BAM{
    label 'verylow'
    container 'ebird013/samtools:1.17'

    input:
        tuple val(sample), file(alignment)
    output:
        tuple val(sample), path("${sample}.bam"), emit: bam
        path("versions.yml"), emit: versions

    script:

    """
    samtools view -bS ${alignment} > ${sample}.bam

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        Samtools: \$(samtools --version 2>&1 | grep "samtools " | sed -e "s/samtools //g")
    END_VERSIONS 
    """
}

process SAMTOOLS_BAMSORT{
    label 'samtoolssort'
    container 'ebird013/samtools:1.17'

    input:
        tuple val(sample), file(alignment)
    output:
        tuple val(sample), path("${sample}_sorted.bam"), emit: sort
        path("versions.yml"), emit: versions

    script:

    """
    samtools sort -m ${task.memory.toGiga()}G -@ ${task.cpus} ${alignment} -o ${sample}_sorted.bam

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        Samtools: \$(samtools --version 2>&1 | grep "samtools " | sed -e "s/samtools //g")
    END_VERSIONS 
    """
}

process SAMTOOLS_MERGE{
    label 'samtoolsmerge'
    container 'ebird013/samtools:1.17'

    input:
        file(bams)
    output:
        path("${params.project_name}.bam"), emit: cat
        path("versions.yml"), emit: versions

    script:

    """
    samtools merge -@ ${task.cpus} -o ${params.project_name}.bam *.bam

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        Samtools: \$(samtools --version 2>&1 | grep "samtools " | sed -e "s/samtools //g")
    END_VERSIONS 
    """
}