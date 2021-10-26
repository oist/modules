#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { UNTAR } from '../../../software/untar/main.nf' addParams( options: [:] )
include { BUSCO } from '../../../software/busco/main.nf' addParams( options: [args: '--offline --augustus_species human'] )

workflow test_busco {
    
    input = [ [ id:'test', single_end:false ], // meta map
              file(params.test_data['homo_sapiens']['genome']['genome_fasta'], checkIfExists: true) ]

    lineage_dataset = [ file('https://github.com/oist/plessy_nf-core_test-datasets/raw/7eeb3bb37369e3f74ab9f9f09a8da362e4699105/data/genomics/homo_sapiens/genome/BUSCO/chr22_odb10.tar.gz', checkIfExists: true) ]

    UNTAR(lineage_dataset)
    BUSCO ( input ,
            [],
            UNTAR.out.untar)
}
