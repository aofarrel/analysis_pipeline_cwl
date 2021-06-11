cwlVersion: v1.1
class: CommandLineTool
label: LocusZoom for GENESIS
doc: |-
  **LocusZoom for GENESIS** visualizes association testing results using the LocusZoom standalone software. This App is a wrapper around LocusZoom standalone software to enable it to work with outputs of GENESIS association pipelines [1]. Main goal of this App is to visualize results of **GENESIS Single Variant Association Test**, however regions from sliding window or aggregate tests with p-values below a certain threshold can be displayed in a separate track. A list of all inputs and parameters with corresponding descriptions can be found at the bottom of this page.

  ***Please note that any cloud infrastructure costs resulting from app and pipeline executions, including the use of public apps, are the sole responsibility of you as a user. To avoid excessive costs, please read the app description carefully and set the app parameters and execution settings accordingly.***

  ### Common Use Cases 
  **LocusZoom for GENESIS** is used to make annotated Manhattan plots on specific regions from association files generated by GENESIS workflows. **LocusZoom for GENESIS** can work with outputs from **GENESIS Single Variant Association Testing**, **GENESIS Aggregate Association Testing** and **GENESIS Sliding Window Association testing** workflows. **Association results file** originating from **GENESIS Single Variant Association Testing** is required even when results from Sliding Window or Aggregate tests are visualized. Sliding Window or Aggregate results are optional inputs provided via the **Track file** input. One PDF file is generated for each locus defined in the **Loci file**.

  Loci to plot are specified in the **Loci file**, with chromosome *chr* and either *variantID* (to specify the reference variant) or *start end* (to indicate a region to plot, in which case the variant with the smallest p-value will be the reference). Population (pop) is either TOPMED or one of the 1000 Genomes populations (hg19:AFR, AMR, ASN, EUR; hg38: AFR, AMR, EUR, EAS, SAS). If pop = TOPMED, LD is computed from the TOPMed data using the sample set in the **LD Sample Include** file. Example of region - defined **Loci file**:

  | chr | start     | end       | pop |
  |-----|-----------|-----------|-----|
  | 1   | 69423922  | 70423922  | AFR |
  | 1   | 94393630  | 95393630  | AMR |
  | 1   | 193326139 | 194326139 | EUR |
  | 2   | 2009400   | 2009430   | EUR |

  Example of variant - defined **Loci file**:

  | variant.id | chr | pop    |
  |------------|-----|--------|
  | 339        | 1   | AFR    |
  | 831        | 1   | topmed |

  For visualization, LD calculation and additional information, **LocusZoom for GENESIS** uses several databases. Due to the size of these databases, they cannot be included in the Docker image, but have to be provided every time this App is run. There are two ways to provide these database to the **GENESIS LocusZoom** App:
  1. Via **Database bundle** input: 
      1. Copy *LZ_Database.tar.gz* file from the Public Files Gallery.
      2. Use the copied file as **Database bundle** input.
  2. Via **Database directory** input:
      1. Copy "*LZ_Database.tar.gz*" from the Public Files Gallery.
      2. Copy the **SBG Decompressor CWL1.0** App from the Public Apps Gallery into the current project.
      3. Run **SBG Decompressor CWL1.0** with *LZ_Database.tar.gz* as an input file, with **Flatten outputs** set to **False**.
      4. Resulting directory should be named *data*. If it is not, rename it so.
      5. Use the *data* directory as the **Database directory** input

  Both approaches come with pros and cons. First approach is very simple and does not lead to additional storage cost as copies of files from the Public Apps Gallery are not billed. However, the resulting task will be longer and more expensive. If **LocusZoom for GENESIS** is run multiple times in the span of several days, it is recommended to use the second approach, and delete the *data* directory when it is no longer used. Time difference between the two approaches is around 10 minutes and around 0.10$ per task (directory approach is cheaper), while the cost of storing the uncompressed directory is around 0.06$/day. 

  ### Changes Introduced by Seven Bridges

   * Multiple loci are run in parallel if the **segment** argument is not provided. If the **segment** argument is provided, only the *n*-th segment from the **Loci file** will be plotted. Number of plots generated in parallel is determined using the **Number of CPUs** argument.

  ### Common Issues and Important Notes

   * Either **Database bundle** or **Database directory** must be provided.
   * All **Association result files**, **GDS files** and **Track files** must follow the same naming standard as in other **GENESIS** workflows, meaning that these files must be provided as one file per chromosome, with the same name except for the number of chromosome, and part of the filename must include *_chr##.* substring, where *##* is replaced by the chromosome number (1-22, X, Y). Note that basename must be identical for all the files in these three input groups, but only within the group, meaning that **GDS files** can have a different basename from **Association result files** and **Track files**.
   * There must be an **Association result file** for each unique chromosome in the **Loci file**
   * **Loci file** must contain exclusively regions or variants, and the type of loci in the file must match the type defined by the **Locus type** app setting.
   * **Loci file** must follow its file specification:
  1. Values and header should be space-delimited.
  2. Header must contain [chr, start, end, population] in case of **Locus type**=*region*, or [variant.id, chr, population] in case **Locus type**=*variant*.
  3. Population must be one of [*AFR, AMR, ASN, EUR, TOPMED*] if **Genome build**=*hg19*, or [*AFR, AMR, EUR, EAS, SAS, TOPMED*] if **Genome build**=*hg38*. Population is not case sensitive.
   * If **Track files** are provided, **Track file type** setting must be set to the appropriate value
   * If **Track files** are provided, **Track threshold** value must be higher than the value of lowest p-value of any variant in all regions. If there is a region without any variants with p-value lower than **Track threshold** the task will fail! It is recommended to set a high value for **Track threshold**, for example *0.1* if it is not known which values to expect. However, some knowledge of variants and regions plotted and setting an appropriate threshold value is recommended.
   * **Number of CPUs** setting must not be larger than the number of threads on the instance. However, it is advised to leave at least one idle thread as additional jobs unrelated to plotting might use it. 

  ### Performance Benchmarking 
  Uploading and unpacking files and databases is a fixed cost for running **LocusZoom for GENESIS** and takes around 10 minutes when working with **Database directory**, or 20 minutes when working with **Database bundle**. The process of generating plots takes minutes and can impact final task execution time and cost only if a large number of plots is generated (more than 100). Default instance cost is 0.48$/h and can be lowered by using [spot instances](https://docs.sevenbridges.com/docs/about-spot-instances). 

  ### References
  [1] [LocusZoom Standalone](https://github.com/UW-GAC/locuszoom-standalone)
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: LoadListingRequirement
- class: ResourceRequirement
  coresMin: |-
    ${
        if(inputs.threads)
            return inputs.threads
        else
            return 1
    }
  ramMin: 4000
- class: DockerRequirement
  dockerPull: uwgac/topmed-master:2.8.1
- class: InitialWorkDirRequirement
  listing:
  - entryname: locuszoom2.config
    writable: false
    entry: |
      ${
          function isNumeric(s) {
              return !isNaN(s - parseFloat(s));
          }
          function find_chromosome(file){
              var chr_array = [];
              var chrom_num = file.split("chr")[1];
              
              if(isNumeric(chrom_num.charAt(1)))
              {
                  chr_array.push(chrom_num.substr(0,2))
              }
              else
              {
                  chr_array.push(chrom_num.substr(0,1))
              }
              return chr_array.toString()
          }
          
          var argument = [];
          var a_file = [].concat(inputs.in_assoc_files)[0];
          var chr = find_chromosome(a_file.basename);
          var path = a_file.path.split('chr' + chr);
          var extension = path[1].split('.')[1];
          
          argument.push('assoc_file ' + '"' + path[0].split('/').pop() + 'chr ' +path[1] + '"');
          
          if(inputs.locus_type)
              argument.push('locus_type "' + inputs.locus_type + '"')
          if(inputs.flanking_region)
              argument.push('flanking_region "' + inputs.flanking_region + '"')
          if(inputs.genome_build)
              argument.push('genome_build "' + inputs.genome_build + '"')
          if(inputs.in_gds_files)
          {
              var g_file = [].concat(inputs.in_gds_files)[0];
              var gchr = find_chromosome(g_file.basename);
              var gpath = g_file.path.split('chr' + gchr);
              argument.push('gds_file ' + '"' + gpath[0].split('/').pop() + 'chr ' +gpath[1] + '"');
          }
          if(inputs.ld_sample_include)
              argument.push('ld_sample_include "' + inputs.ld_sample_include.path + '"')
          if(inputs.in_loci_file)
              argument.push('locus_file "' + inputs.in_loci_file.path + '"')
              
          if(inputs.in_track_files)
          {
              var t_file = [].concat(inputs.in_track_files)[0];
              var tchr = find_chromosome(t_file.basename);
              var tpath = t_file.path.split('chr' + tchr);
              argument.push('track_file ' + '"' + tpath[0].split('/').pop() + 'chr ' +tpath[1] + '"');
          }
          if(inputs.track_file_type)
              argument.push('track_file_type "' + inputs.track_file_type + '"')
          if(inputs.track_label)
              argument.push('track_label "' + inputs.track_label + '"')
          if(inputs.track_threshold)
              argument.push('track_threshold "' + inputs.track_threshold + '"')
          if(inputs.signif_line)
              argument.push('signif_line "' + inputs.signif_line + '"')
          if(inputs.out_prefix)
              argument.push('out_prefix "' + inputs.out_prefix + '"')
          
          argument.push('\n');
          return argument.join('\n')
          
      }
- class: InlineJavascriptRequirement
  expressionLib:
  - |2-

    var setMetadata = function(file, metadata) {
        if (!('metadata' in file)) {
            file['metadata'] = {}
        }
        for (var key in metadata) {
            file['metadata'][key] = metadata[key];
        }
        return file
    };
    var inheritMetadata = function(o1, o2) {
        var commonMetadata = {};
        if (!o2) {
            return o1;
        };
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
            for (var key in commonMetadata) {
                if (!(key in example)) {
                    delete commonMetadata[key]
                }
            }
        }
        if (!Array.isArray(o1)) {
            o1 = setMetadata(o1, commonMetadata)
            if (o1.secondaryFiles) {
                o1.secondaryFiles = inheritMetadata(o1.secondaryFiles, o2)
            }
        } else {
            for (var i = 0; i < o1.length; i++) {
                o1[i] = setMetadata(o1[i], commonMetadata)
                if (o1[i].secondaryFiles) {
                    o1[i].secondaryFiles = inheritMetadata(o1[i].secondaryFiles, o2)
                }
            }
        }
        return o1;
    };

inputs:
- id: out_prefix
  label: Output prefix
  doc: Prefix for files created by this script.
  type: string?
  sbg:category: Configuration
- id: in_assoc_files
  label: Association results files
  doc: |-
    Files with single-variant association test results. File has to follow same naming specification as GENESIS Association Test files (basename_chr##.RData).
  type: File[]
  sbg:category: Input files
  sbg:fileTypes: RDATA
- id: in_loci_file
  label: Locus file
  doc: |-
    Text file with columns chr, pop and either variantID (for locus_type=variant) or start, end (for locus_type=region)
  type: File
  sbg:category: Input files
  sbg:fileTypes: TXT, BED
- id: locus_type
  label: Locus type
  doc: Type of region to plot (variant with flanking region, or region)
  type:
  - 'null'
  - name: locus_type
    type: enum
    symbols:
    - variant
    - region
  sbg:category: Configuration
  sbg:toolDefaultValue: variant
- id: flanking_region
  label: Flanking region
  doc: Flanking region in kb. Default is 500kb.
  type: int?
  sbg:category: Configuration
  sbg:toolDefaultValue: '500'
- id: in_gds_files
  label: GDS files
  doc: GDS file to use for calculating LD
  type: File[]?
  sbg:category: Input files
  sbg:fileTypes: GDS
- id: genome_build
  label: Genome build
  doc: 'Genome build (hg19 or hg38). Default: hg38'
  type:
  - 'null'
  - name: genome_build
    type: enum
    symbols:
    - hg19
    - hg38
  default: hg38
  sbg:category: Configuration
  sbg:toolDefaultValue: hg38
- id: ld_sample_include
  label: LD sample include
  doc: RData file with vector of sample.id to include when calculating LD.
  type: File?
  sbg:category: Input files
  sbg:fileTypes: RDATA
- id: in_track_files
  label: Track files
  doc: |-
    File with aggregate or window association test results. Regions will be displayed in a track in the LocusZoom plot. Include a space to insert chromosome.
  type: File[]?
  sbg:category: Input files
  sbg:fileTypes: RDATA
- id: track_file_type
  label: Track file type
  doc: Type of association regions in track_file (window or aggregate).
  type:
  - 'null'
  - name: track_file_type
    type: enum
    symbols:
    - window
    - aggregate
  sbg:category: Configuration
  sbg:toolDefaultValue: window
- id: track_label
  label: Track label
  doc: Label to display to the right of the track in the plot.
  type: string?
  sbg:category: Configuration
- id: track_threshold
  label: Track threshold
  doc: P-value threshold for selecting regions to display.
  type: float?
  sbg:category: Configuration
  sbg:toolDefaultValue: '5e-8'
- id: database_directory
  label: Database directory
  doc: |-
    Directory containing databases used for LD calculation and annotation. It can be obtained by decompressing LD_Database.tar.gz file found in the public files gallery, or can be downloaded from LocusZoom Standalone github page.
  type: Directory?
  loadListing: deep_listing
  sbg:category: General
- id: segment
  label: Segment
  doc: |-
    If provided, only a single segment from Locus File will be used. Otherwise, one PDF file will be provided per line in the Locus File.
  type: int?
  sbg:toolDefaultValue: '1'
- id: threads
  label: Number of CPUs
  doc: |-
    Number of plots to create in parallel. Must not be larger than number of threads on the instance. Default: 4
  type: int?
  sbg:category: General
  sbg:toolDefaultValue: '4'
- id: signif_line
  label: Significance line
  doc: 'Where to draw significance line on plots. Default: 5e-8'
  type: float?
  sbg:category: Configuration
  sbg:toolDefaultValue: '5e-8'
- id: in_database_compressed
  label: Database bundle
  doc: |-
    Compressed database directory. Available as LZ_Database.tar.gz in the public file gallery. Required if Database Directory is not provided.
  type: File?
  sbg:category: General
  sbg:fileTypes: TAR.GZ

outputs:
- id: out_pdf_reports
  label: Locuszoom plots
  doc: One LZ plot per locus.
  type: File[]?
  outputBinding:
    glob: '*.pdf'
    outputEval: $(inheritMetadata(self, inputs.assoc_file))
  sbg:fileTypes: PDF

baseCommand: []
arguments:
- prefix: ''
  position: 0
  valueFrom: |-
    ${
        if(inputs.database_directory)
        {
            return "mkdir /usr/local/src/locuszoom-standalone/data && mkdir /usr/local/src/locuszoom-standalone/data/database && export PATH=/usr/local/locuszoom-standalone/bin:$PATH && cp -r " + inputs.database_directory.path + "/. /usr/local/src/locuszoom-standalone/data/ && "
        }
        else
        {
            if(inputs.in_database_compressed)
                return "mkdir /usr/local/src/locuszoom-standalone/data && mkdir /usr/local/src/locuszoom-standalone/data/database && export PATH=/usr/local/locuszoom-standalone/bin:$PATH && tar -xzf " + inputs.in_database_compressed.path + " -C /usr/local/src/locuszoom-standalone/ && "
            else
            {
                var error = "Database not provided! Please provide LZ database either as Database bundle or Database directory.";
                throw error;
            }
                
        }
        
    }
  shellQuote: false
- prefix: ''
  position: 10
  valueFrom: |-
    ${
        if (inputs.segment)
            return "Rscript /usr/local/analysis_pipeline/R/locuszoom.R locuszoom2.config --segment " + inputs.segment
        else
        {
            var num_of_threads = 4;
            if(inputs.threads)
                num_of_threads = inputs.threads
            return "seq 1 $(expr $(wc -l " + inputs.in_loci_file.path + "| awk '{ print $1 }') - 1) | xargs -P" + num_of_threads + " -n1 -t -I % Rscript /usr/local/analysis_pipeline/R/locuszoom.R locuszoom2.config --segment %"
        }
            
    }
  shellQuote: false
- prefix: ''
  position: 5
  valueFrom: |-
    ${
        var command = '';
        for(var i=0; i<inputs.in_assoc_files.length; i++)
            command += "ln -s " + inputs.in_assoc_files[i].path + " " + inputs.in_assoc_files[i].path.split("/").pop() + " && "
        if(inputs.in_gds_files)
            for(var i=0; i<inputs.in_gds_files.length; i++)
                command += "ln -s " + inputs.in_gds_files[i].path + " " + inputs.in_gds_files[i].path.split("/").pop() + " && "
        if(inputs.in_track_files)
            for(var i=0; i<inputs.in_track_files.length; i++)
                command += "ln -s " + inputs.in_track_files[i].path + " " + inputs.in_track_files[i].path.split("/").pop() + " && "
        
        return command
    }
  shellQuote: false

hints:
- class: sbg:AWSInstanceType
  value: c5.2xlarge;ebs-gp2;512
- class: sbg:GoogleInstanceType
  value: n1-standard-8;pd-ssd;512
id: |-
  https://api.sb.biodatacatalyst.nhlbi.nih.gov/v2/apps/admin/sbg-public-data/genesis-locuszoom/5/raw/
sbg:appVersion:
- v1.1
sbg:categories:
- Plotting and Rendering
sbg:content_hash: a041992e1c3de0c2f23fcd8872a361b5e3c5b384f3644fb03e0ad1fa4318546ab
sbg:contributors:
- admin
sbg:createdBy: admin
sbg:createdOn: 1608749020
sbg:expand_workflow: false
sbg:id: admin/sbg-public-data/genesis-locuszoom/5
sbg:image_url:
sbg:latestRevision: 5
sbg:license: GNU General Public License v3
sbg:links:
- id: https://genome.sph.umich.edu/wiki/LocusZoom_Standalone
  label: Wiki
- id: https://github.com/statgen/locuszoom-standalone
  label: github
- id: https://genome.sph.umich.edu/wiki/LocusZoom_Standalone#License
  label: License
sbg:modifiedBy: admin
sbg:modifiedOn: 1617276240
sbg:project: admin/sbg-public-data
sbg:projectName: SBG Public Data
sbg:publisher: sbg
sbg:revision: 5
sbg:revisionNotes: Description update
sbg:revisionsInfo:
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1608749020
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1608749020
  sbg:revision: 1
  sbg:revisionNotes: Public version
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1608749020
  sbg:revision: 2
  sbg:revisionNotes: Publishing revision
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1608749021
  sbg:revision: 3
  sbg:revisionNotes: Latest version
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1617276240
  sbg:revision: 4
  sbg:revisionNotes: Naming and description update
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1617276240
  sbg:revision: 5
  sbg:revisionNotes: Description update
sbg:sbgMaintained: false
sbg:toolAuthor: TopMed DCC
sbg:toolkit: LocusZoom Standalone
sbg:validationErrors: []
sbg:wrapperAuthor: SBG