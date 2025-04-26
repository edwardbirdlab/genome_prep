process HISAT2 {
    label 'midmem'
    container 'quay.io/biocontainers/hisat2:2.2.1--h503566f_8'

    input:
        tuple val(sample), file(fq1), file(fq2), file(ref)
    output:
        tuple val(sample), path("${sample}_hisat2.sam"), emit: sam

    script:

    """
    mkdir -p temp
    export TMPDIR=\$(pwd)/temp

    hisat2-build ${ref} index

    hisat2 -p ${task.cpus} \
        -x index \
        -1 ${fq1} -2 ${fq2} \
        --dta \
        -S ${sample}_hisat2.sam
    """
}