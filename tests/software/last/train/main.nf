#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { LAST_LASTDB } from '../../../../software/last/lastdb/main.nf' addParams( options: [:] )
include { LAST_TRAIN } from '../../../../software/last/train/main.nf' addParams( options: [:] )

workflow test_last_train {
    
    to_index =   [ [ id:'test' ], // meta map
                   file(params.test_data['sarscov2']['genome']['genome_fasta'], checkIfExists: true)
                 ]

    input =      [ [ id:'test' ], // meta map
                   file(params.test_data['sarscov2']['illumina']['contigs_fasta'], checkIfExists: true)
                 ]

    LAST_LASTDB ( to_index )
    LAST_TRAIN ( LAST_LASTDB.out.index, input )
}