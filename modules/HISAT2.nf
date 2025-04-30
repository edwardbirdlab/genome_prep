process HISAT2 {
    label 'midmem'
    container 'https://depot.galaxyproject.org/singularity/mulled-v2-a97e90b3b802d1da3d6958e0867610c718cb5eb1:2cdf6bf1e92acbeb9b2834b1c58754167173a410-0'

    input:
        tuple val(sample), file(fq1), file(fq2), file(ref)
    output:
        tuple val(sample), path("${sample}_hisat2.sam"), emit: sam

    script:

    """
    mkdir -p \$TMPDIR/${sample}

    cp ${fq1} \$TMPDIR
    cp ${fq2} \$TMPDIR

    hisat2-build ${ref} index

    hisat2 -p ${task.cpus} \
        -x index \
        -1 \$TMPDIR/${fq1} -2 \$TMPDIR/${fq2} \
        --dta \
        -S ${sample}_hisat2.sam \
        --temp-directory \$TMPDIR/${sample}
    """
}