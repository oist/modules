#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { LAST_LASTDB } from '../../../../software/last/lastdb/main.nf' addParams( options: [:] )
include { LAST_LASTAL } from '../../../../software/last/lastal/main.nf' addParams( options: [:] )

workflow test_last_lastal {
    
    to_index =   [ [ id:'test' ], // meta map
                   file(params.test_data['sarscov2']['genome']['genome_fasta'], checkIfExists: true)
                 ]

    param_file = [ [ id:'test' ], // meta map
                   file('param_file_dummy')
                 ]

    input =      [ [ id:'test' ], // meta map
                   file(params.test_data['sarscov2']['illumina']['contigs_fasta'], checkIfExists: true)
                 ]

    LAST_LASTDB ( to_index )
    LAST_LASTAL ( LAST_LASTDB.out.index, param_file, input )
}
