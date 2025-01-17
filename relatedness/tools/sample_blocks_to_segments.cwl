cwlVersion: v1.2
class: CommandLineTool
label: sample blocks to segments
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: InlineJavascriptRequirement

inputs:
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

outputs:
- id: segments
  type:
  - 'null'
  - type: array
    items: int
  outputBinding:
    outputEval: |-
      ${ 
          var blocks = [];
          var N = inputs.n_sample_blocks;
          for (var i = 1; i <= N; i++) {
              for (var j = i; j <= N; j++) {
                  blocks.push([i, j]);
              }
          }
          
          var segments = [];
          for (var i = 1; i <= blocks.length; i++)
              segments.push(i)
              
          return segments;
      }

baseCommand: []
id: |-
  https://api.sb.biodatacatalyst.nhlbi.nih.gov/v2/apps/smgogarten/genesis-relatedness-pre-build/sample-blocks-to-segments/2/raw/
sbg:appVersion:
- v1.2
sbg:content_hash: a7be306a45f3d66a0c82a476413df91fbce288099db016d6acb3c435ebc96e015
sbg:contributors:
- smgogarten
sbg:createdBy: smgogarten
sbg:createdOn: 1609451972
sbg:id: smgogarten/genesis-relatedness-pre-build/sample-blocks-to-segments/2
sbg:image_url:
sbg:latestRevision: 2
sbg:modifiedBy: smgogarten
sbg:modifiedOn: 1623740857
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
  sbg:modifiedOn: 1609451972
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609451996
  sbg:revision: 1
  sbg:revisionNotes: import to pre-build project
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623740857
  sbg:revision: 2
  sbg:revisionNotes: |-
    Uploaded using sbpack v2020.10.05. 
    Source: 
    repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
    file: 
    commit: 6d87792
sbg:sbgMaintained: false
sbg:validationErrors: []
