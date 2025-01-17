cwlVersion: v1.2
class: CommandLineTool
label: pcrelate
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: DockerRequirement
  dockerPull: uwgac/topmed-master:2.10.0
- class: InitialWorkDirRequirement
  listing:
  - entryname: pcrelate.config
    writable: false
    entry: |-
      ${
          var config = ""

          if (inputs.gds_file) 
            config += "gds_file \"" + inputs.gds_file.path + "\"\n"
            
          if (inputs.pca_file) 
            config += "pca_file \"" + inputs.pca_file.path + "\"\n"
                  
          if (inputs.beta_file) 
            config += "beta_file \"" + inputs.beta_file.path + "\"\n"
            
          if (inputs.variant_include_file) 
            config += "variant_include_file \"" + inputs.variant_include_file.path + "\"\n"

          if (inputs.out_prefix)
            config += "out_prefix \"" + inputs.out_prefix  + "\"\n"
        	
        	if (inputs.n_pcs)
            config += "n_pcs " + inputs.n_pcs + "\n"
          
          if (inputs.sample_include_file) 
            config += "sample_include_file \"" + inputs.sample_include_file.path + "\"\n"
            
        	if (inputs.n_sample_blocks) 
            config += "n_sample_blocks " + inputs.n_sample_blocks + "\n"
            
          if (!inputs.ibd_probs)
            config += "ibd_probs FALSE" + "\n"
            
          return config
      }
- class: InlineJavascriptRequirement

inputs:
- id: gds_file
  label: GDS File
  doc: Input GDS file. It is recommended to use an LD pruned file with all chromosomes.
  type: File
  sbg:category: Input Files
  sbg:fileTypes: GDS
- id: pca_file
  label: PCA file
  doc: |-
    RData file with PCA results from PC-AiR workflow; used to adjust for population structure.
  type: File
  sbg:category: Input Files
  sbg:fileTypes: RDATA
- id: beta_file
  label: ISAF beta values
  doc: RData file with output from pcrelate_beta tool.
  type: File
  sbg:category: Input Files
  sbg:fileTypes: RDATA
- id: n_pcs
  label: Number of PCs
  doc: Number of PCs to use in adjusting for ancestry.
  type:
  - 'null'
  - int
  sbg:category: Input Options
  sbg:toolDefaultValue: '3'
- id: out_prefix
  label: Output prefix
  doc: Prefix for output files.
  type:
  - 'null'
  - string
  sbg:category: Input Options
  sbg:toolDefaultValue: pcrelate
- id: variant_include_file
  label: Variant include file
  doc: |-
    RData file with vector of variant.id to include. If not provided, all variants in the GDS file are included.
  type:
  - 'null'
  - File
  sbg:category: Input Files
- id: variant_block_size
  label: Variant block size
  doc: Number of variants to read in a single block.
  type:
  - 'null'
  - int
  default: 1024
  sbg:category: Input Options
  sbg:toolDefaultValue: '1024'
- id: sample_include_file
  label: Sample Include file
  doc: |-
    RData file with vector of sample.id to include. If not provided, all samples in the GDS file are included.
  type:
  - 'null'
  - File
  sbg:category: Input Files
  sbg:fileTypes: RDATA
- id: n_sample_blocks
  label: Number of sample blocks
  doc: |-
    Number of blocks to divide samples into for parallel computation. Adjust depending on computer memory and number of samples in the analysis.
  type:
  - 'null'
  - int
  default: 1
  sbg:category: Input Options
  sbg:toolDefaultValue: '1'
- id: segment
  label: Sample block combination
  doc: |-
    If number of sample blocks is > 1, run on this combination of sample blocks. Allowed values are 1:N where N is the number of possible combinations of sample blocks [i, j].
  type:
  - 'null'
  - int
  default: 1
  sbg:category: Input Options
  sbg:toolDefaultValue: '1'
- id: ibd_probs
  label: Return IBD probabilities?
  doc: |-
    Set this to FALSE to skip computing pairwise IBD probabilities (k0, k1, k2). If FALSE, the plottng step is also skipped, as it requires values for k0.
  type:
  - 'null'
  - boolean
  sbg:category: Input Options
  sbg:toolDefaultValue: 'TRUE'

outputs:
- id: pcrelate
  label: PC-Relate results
  doc: RData files with PC-Relate results for each sample block.
  type:
  - 'null'
  - File
  outputBinding:
    glob: '*.RData'
  sbg:fileTypes: RDATA
stdout: job.out.log

baseCommand:
- R -q --vanilla
arguments:
- prefix: <
  position: 3
  valueFrom: /usr/local/analysis_pipeline/R/pcrelate.R
  shellQuote: false
- prefix: --args
  position: 1
  valueFrom: pcrelate.config
  shellQuote: false
- prefix: --segment
  position: 2
  valueFrom: ${ return inputs.segment }
  shellQuote: false

hints:
- class: sbg:SaveLogs
  value: job.out.log
- class: sbg:SaveLogs
  value: pcrelate.config
id: |-
  https://api.sb.biodatacatalyst.nhlbi.nih.gov/v2/apps/smgogarten/genesis-relatedness-pre-build/pcrelate/2/raw/
sbg:appVersion:
- v1.2
sbg:content_hash: a72bf7d96b4bc1d48e7485a9f90ed1e593edc3fd258ffa279797130eb6f102ba2
sbg:contributors:
- smgogarten
sbg:createdBy: smgogarten
sbg:createdOn: 1609451776
sbg:id: smgogarten/genesis-relatedness-pre-build/pcrelate/2
sbg:image_url:
sbg:latestRevision: 2
sbg:modifiedBy: smgogarten
sbg:modifiedOn: 1623740858
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
  sbg:modifiedOn: 1609451776
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609451801
  sbg:revision: 1
  sbg:revisionNotes: import to pre-build project
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623740858
  sbg:revision: 2
  sbg:revisionNotes: |-
    Uploaded using sbpack v2020.10.05. 
    Source: 
    repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
    file: 
    commit: 6d87792
sbg:sbgMaintained: false
sbg:validationErrors: []
