process HISAT2 {
    label 'hisat'
    container 'ebird013/hisat2:latest'

    input:
        tuple val(sample), file(fq1), file(fq2), file(ref)
    output:
        tuple val(sample), path("${sample}_hisat2.sam"), emit: sam

    script:

    """
    mkdir -p \$TMPDIR/hisat2_job
    cd \$TMPDIR/hisat2_job

    cp ${fq1} \$TMPDIR
    cp ${fq2} \$TMPDIR
    cp ${ref} \$TMPDIR

    cd \$TMPDIR/hisat2_job

    hisat2-build ${ref} index

    hisat2 -p ${task.cpus} \
        -x index \
        -1 ${fq1} \
        -2 ${fq2} \
        --dta \
        -S ${sample}_hisat2.sam \

    cp ${sample}_hisat2.sam "$NF_WORK/"

    """
}