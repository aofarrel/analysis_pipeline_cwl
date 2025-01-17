cwlVersion: v1.2
class: CommandLineTool
label: plink_make-bed
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: DockerRequirement
  dockerPull: uwgac/topmed-master:2.10.0
- class: InlineJavascriptRequirement
  expressionLib:
  - |2-

    var setMetadata = function(file, metadata) {
        if (!('metadata' in file))
            file['metadata'] = metadata;
        else {
            for (var key in metadata) {
                file['metadata'][key] = metadata[key];
            }
        }
        return file
    };

    var inheritMetadata = function(o1, o2) {
        var commonMetadata = {};
        if (!Array.isArray(o2)) {
            o2 = [o2]
        }
        for (var i = 0; i < o2.length; i++) {
            var example = o2[i]['metadata'];
            for (var key in example) {
                if (i == 0)
                    commonMetadata[key] = example[key];
                else {
                    if (!(commonMetadata[key] == example[key])) {
                        delete commonMetadata[key]
                    }
                }
            }
        }
        if (!Array.isArray(o1)) {
            o1 = setMetadata(o1, commonMetadata)
        } else {
            for (var i = 0; i < o1.length; i++) {
                o1[i] = setMetadata(o1[i], commonMetadata)
            }
        }
        return o1;
    };

inputs:
- id: bedfile
  label: BED File
  doc: Bedfile to prepare. Prefix will be used for constructing output filename.
  type: File
  secondaryFiles:
  - pattern: ^.fam
    required: true
  - pattern: ^.bim
    required: true
  sbg:category: Input Files
  sbg:fileTypes: BED

outputs:
- id: bed_file
  label: Processed BED
  doc: BED file processed by plink
  type: File
  secondaryFiles:
  - pattern: ^.bim
    required: true
  - pattern: ^.fam
    required: true
  outputBinding:
    glob: '*_recode.bed'
    outputEval: $(inheritMetadata(self, inputs.bedfile))
  sbg:fileTypes: BED
stdout: job.out.log

baseCommand:
- plink --make-bed
arguments:
- prefix: --bfile
  position: 1
  valueFrom: ${ return inputs.bedfile.path.split('.').slice(0,-1).join('.') }
  shellQuote: false
- prefix: --out
  position: 2
  valueFrom: ${ return inputs.bedfile.nameroot + "_recode" }
  shellQuote: false

hints:
- class: sbg:SaveLogs
  value: job.out.log
id: |-
  https://api.sb.biodatacatalyst.nhlbi.nih.gov/v2/apps/smgogarten/genesis-relatedness-pre-build/plink-make-bed/4/raw/
sbg:appVersion:
- v1.2
sbg:content_hash: addfad77655567300c74ccb994be41549ec8e54a4571c3cc153bfba9c5cfbc61c
sbg:contributors:
- smgogarten
sbg:createdBy: smgogarten
sbg:createdOn: 1609451922
sbg:id: smgogarten/genesis-relatedness-pre-build/plink-make-bed/4
sbg:image_url:
sbg:latestRevision: 4
sbg:modifiedBy: smgogarten
sbg:modifiedOn: 1623450741
sbg:project: smgogarten/genesis-relatedness-pre-build
sbg:projectName: GENESIS relatedness - Pre-build
sbg:publisher: sbg
sbg:revision: 4
sbg:revisionNotes: |-
  Uploaded using sbpack v2020.10.05. 
  Source: 
  repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
  file: 
  commit: c9c8b8d
sbg:revisionsInfo:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609451922
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609451941
  sbg:revision: 1
  sbg:revisionNotes: import to pre-build project
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623444723
  sbg:revision: 2
  sbg:revisionNotes: |-
    Uploaded using sbpack v2020.10.05. 
    Source: 
    repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
    file: 
    commit: c9c8b8d
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623445038
  sbg:revision: 3
  sbg:revisionNotes: |-
    Uploaded using sbpack v2020.10.05. 
    Source: 
    repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
    file: 
    commit: c9c8b8d
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623450741
  sbg:revision: 4
  sbg:revisionNotes: |-
    Uploaded using sbpack v2020.10.05. 
    Source: 
    repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
    file: 
    commit: c9c8b8d
sbg:sbgMaintained: false
sbg:validationErrors: []
