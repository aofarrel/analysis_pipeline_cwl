cwlVersion: v1.1
class: CommandLineTool
label: check_merged_gds
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: DockerRequirement
  dockerPull: uwgac/topmed-master:2.8.1
- class: InitialWorkDirRequirement
  listing:
  - entryname: check_merged_gds.config
    writable: false
    entry: |
      ${
          var config = "";
          
          if(inputs.gds_file)
              var gds_name = "";
              var gds_file = [].concat(inputs.gds_file)
              var gds = gds_file[0].path;
              var gds_first_part = gds.split('chr')[0];
              var gds_second_part = gds.split('chr')[1].split('.');
              gds_second_part.shift();
              gds_name = gds_first_part + 'chr .' + gds_second_part.join('.');
              config += "gds_file \"" + gds_name + "\"\n"

          if (inputs.merged_gds_file)
              config += "merged_gds_file \"" + inputs.merged_gds_file.path + "\"\n"

          return config
      }
- class: InlineJavascriptRequirement

inputs:
- id: gds_file
  label: GDS File
  doc: Base reference file for comparison.
  type: File
  sbg:category: Inputs
  sbg:fileTypes: GDS
- id: merged_gds_file
  label: Merged GDS file
  doc: |-
    Output of merge_gds script. This file is being checked against starting gds file.
  type: File
  sbg:category: Inputs
  sbg:fileTypes: GDS

outputs: []
stdout: job.out.log

baseCommand:
- R -q --vanilla
arguments:
- prefix: <
  position: 3
  valueFrom: /usr/local/analysis_pipeline/R/check_merged_gds.R
  shellQuote: false
- prefix: --chromosome
  position: 2
  valueFrom: "${\n    return inputs.gds_file.path.split('chr')[1].split('.')[0]\n}"
  shellQuote: false
- prefix: --args
  position: 1
  valueFrom: check_merged_gds.config
  shellQuote: false

hints:
- class: sbg:SaveLogs
  value: job.out.log
- class: sbg:SaveLogs
  value: check_merged_gds.config
id: smgogarten/genesis-relatedness-pre-build/check-merged-gds/1
sbg:appVersion:
- v1.1
sbg:content_hash: a9b81533d98dd08ea9973798dc89b49c33e9557371e0274b95bf35c938f7668ed
sbg:contributors:
- smgogarten
sbg:createdBy: smgogarten
sbg:createdOn: 1609450408
sbg:id: smgogarten/genesis-relatedness-pre-build/check-merged-gds/1
sbg:image_url:
sbg:latestRevision: 1
sbg:modifiedBy: smgogarten
sbg:modifiedOn: 1609450694
sbg:project: smgogarten/genesis-relatedness-pre-build
sbg:projectName: GENESIS relatedness - Pre-build
sbg:publisher: sbg
sbg:revision: 1
sbg:revisionNotes: import to pre-build project
sbg:revisionsInfo:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609450408
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609450694
  sbg:revision: 1
  sbg:revisionNotes: import to pre-build project
sbg:sbgMaintained: false
sbg:validationErrors: []
