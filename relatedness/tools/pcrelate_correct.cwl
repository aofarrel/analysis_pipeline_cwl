cwlVersion: v1.2
class: CommandLineTool
label: pcrelate_correct
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: DockerRequirement
  dockerPull: uwgac/topmed-master:2.10.0
- class: InitialWorkDirRequirement
  listing:
  - entryname: pcrelate_correct.config
    writable: false
    entry: |-
      ${
          var config = ""

          if (inputs.pcrelate_block_files) {
              var prefix = inputs.pcrelate_block_files[0].nameroot.split("_block_")[0]
              config += "pcrelate_prefix \"" + prefix + "\"\n"
          }
            
        	if (inputs.n_sample_blocks) 
              config += "n_sample_blocks " + inputs.n_sample_blocks + "\n"
            
          if (inputs.sparse_threshold) 
              config += "sparse_threshold " + inputs.sparse_threshold + "\n"  
          
          return config
      }
- class: InlineJavascriptRequirement

inputs:
- id: n_sample_blocks
  label: Number of sample blocks
  doc: |-
    Number of blocks to divide samples into for parallel computation. Adjust depending on computer memory and number of samples in the analysis.
  type: int
  default: 1
  sbg:category: Input Options
  sbg:toolDefaultValue: '1'
- id: pcrelate_block_files
  label: PCRelate files for all sample blocks
  doc: PCRelate files for all sample blocks
  type:
    type: array
    items: File
  sbg:category: Input Files
  sbg:fileTypes: RDATA
- id: sparse_threshold
  label: Sparse threshold
  doc: |-
    Threshold for making the output kinship matrix sparse. A block diagonal matrix will be created such that any pair of samples with a kinship estimate greater than the threshold is in the same block; all pairwise estimates within a block are kept, and pairwise estimates between blocks are set to 0.
  type:
  - 'null'
  - float
  default: 0.02209709
  sbg:category: Input Options
  sbg:toolDefaultValue: 2^(-11/2) (~0.022, 4th degree)

outputs:
- id: pcrelate_output
  label: PC-Relate output file
  doc: PC-Relate output file with all samples
  type:
  - 'null'
  - File
  outputBinding:
    glob: '*_pcrelate.RData'
  sbg:fileTypes: RDATA
- id: pcrelate_matrix
  label: Kinship matrix
  doc: |-
    A block diagonal matrix of pairwise kinship estimates with sparsity set by sparse_threshold. Samples are clustered into blocks of relatives based on `sparse_threshold`; all kinship estimates within a block are kept, and kinship estimates between blocks are set to 0. When `sparse_threshold` is 0, this is a dense matrix with all pairwise kinship estimates.
  type:
  - 'null'
  - File
  outputBinding:
    glob: '*_pcrelate_Matrix.RData'
  sbg:fileTypes: RDATA
stdout: job.out.log

baseCommand: []
arguments:
- prefix: <
  position: 3
  valueFrom: /usr/local/analysis_pipeline/R/pcrelate_correct.R
  shellQuote: false
- prefix: --args
  position: 2
  valueFrom: pcrelate_correct.config
  shellQuote: false
- prefix: ''
  position: 0
  valueFrom: |-
    ${
        var cmd_line = ""
        
        for (var i=0; i<inputs.pcrelate_block_files.length; i++)
            cmd_line += "ln -s " + inputs.pcrelate_block_files[i].path + " " + inputs.pcrelate_block_files[i].basename + " && "
        
        return cmd_line
    }
  shellQuote: false
- prefix: ''
  position: 1
  valueFrom: R -q --vanilla
  shellQuote: false

hints:
- class: sbg:SaveLogs
  value: job.out.log
- class: sbg:SaveLogs
  value: pcrelate_correct.config
id: |-
  https://api.sb.biodatacatalyst.nhlbi.nih.gov/v2/apps/smgogarten/genesis-relatedness-pre-build/pcrelate-correct/2/raw/
sbg:appVersion:
- v1.2
sbg:content_hash: af4cd928c332332da31020081a18ba26d12d920c77c9cfe04d7e4cefd3e702cf1
sbg:contributors:
- smgogarten
sbg:createdBy: smgogarten
sbg:createdOn: 1609451869
sbg:id: smgogarten/genesis-relatedness-pre-build/pcrelate-correct/2
sbg:image_url:
sbg:latestRevision: 2
sbg:modifiedBy: smgogarten
sbg:modifiedOn: 1623740859
sbg:project: smgogarten/genesis-relatedness-pre-build
sbg:projectName: GENESIS relatedness - Pre-build
sbg:publisher: sbg
sbg:revision: 2
sbg:revisionNotes: |-
  Uploaded using sbpack v2020.10.05. 
  Source: 
  repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
  file: 
  commit: 6d87792
sbg:revisionsInfo:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609451869
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609451892
  sbg:revision: 1
  sbg:revisionNotes: import to pre-build project
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623740859
  sbg:revision: 2
  sbg:revisionNotes: |-
    Uploaded using sbpack v2020.10.05. 
    Source: 
    repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
    file: 
    commit: 6d87792
sbg:sbgMaintained: false
sbg:validationErrors: []
