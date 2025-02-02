process STAR {
    label 'midmem'
    container 'quay.io/biocontainers/star:2.7.11b--h5ca1c30_5'

    input:
        tuple val(sample), file(fq1), file(fq2), file(ref)
    output:
        tuple val(sample), path("${sample}_star.sam"), emit: sam

    script:

    """
    mkdir ${sample}_index
    STAR --runThreadN ${task.cpus} --runMode genomeGenerate --genomeDir ${sample}_index --genomeFastaFiles ${ref} --sjdbOverhang ${params.read_len}
    STAR --runThreadN ${task.cpus} --genomeDir ${sample}_index --readFilesCommand zcat --outSAMunmapped Within --readFilesIn ${fq1} ${fq2}
    mv Aligned.out.sam ${sample}_star.sam
    """
}