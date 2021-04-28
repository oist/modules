// Import generic module functions
include { initOptions; saveFiles; getSoftwareName } from './functions'

params.options = [:]
options        = initOptions(params.options)

process LAST_LASTAL {
    tag "$meta.id"
    label 'process_high'
    publishDir "${params.outdir}",
        mode: params.publish_dir_mode,
        saveAs: { filename -> saveFiles(filename:filename, options:params.options, publish_dir:getSoftwareName(task.process), publish_id:meta.id) }

    conda (params.enable_conda ? "bioconda::last=1219" : null)
    if (workflow.containerEngine == 'singularity' && !params.singularity_pull_docker_container) {
        container "https://depot.galaxyproject.org/singularity/last:1219--h2e03b76_0"
    } else {
        container "quay.io/biocontainers/last:1219--h2e03b76_0"
    }

    input:
    tuple val(meta_index),  path(index)
    tuple val(meta_ignore), path(param_file)
    tuple val(meta),        path(fastx)

    output:
    tuple val(meta),  path("*.maf.gz"), emit: maf
    path "*.version.txt"              , emit: version

    script:
    def software = getSoftwareName(task.process)
    def trained_params = param_file.exists() ? "-p ${param_file}"  : ""
    """
    lastal \\
        ${trained_params} \\
        ${options.args} \\
        -P $task.cpus \\
        ${index}/${meta_index.id} \\
        ${fastx} \\
        | gzip --no-name > ${meta.id}__${meta_index.id}.maf.gz
    # gzip needs --no-name otherwise it puts a timestamp in the file,
    # which makes its checksum non-reproducible.

    echo \$(lastal --version 2>&1) | sed 's/lastal //' > ${software}.version.txt
    """
}
