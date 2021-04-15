#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { LAST_LASTDB } from '../../../../software/last/lastdb/main.nf' addParams( options: [:] )

workflow test_last_lastdb {

    input = [ [ id:'test' ], // meta map
              file(params.test_data['sarscov2']['genome']['genome_fasta'], checkIfExists: true)
            ]

    LAST_LASTDB ( input )
}
