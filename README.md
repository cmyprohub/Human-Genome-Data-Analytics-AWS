# CCAGenomePipeline

1) Load up the ADAM generated parquet files into S3 - You have to download this from onedrive. Its 100 MB and too big for GIT

/adam_processes_parquet.txt

2) Load up the population CSV file into S3

/population_data.txt

3) Run the Athena DDLs to create tables - population, variant and clinvar. You will have to change your S3 path in the DDL

/ddl

4) Run a few sample SQL selects & joins on the table in Athena. There is a sample SQL in GIT.

/athena_queries/sample_queries.txt

5) Connect to Athena tables with the sample Sagemaker python notebook and run some sample query from python on the tables. You will have to change to your S3 and athena location



6) Optionally connect via R. I have an EC2 AMI and I can spin it up later so that we can use the R Studio Interface from the web to connect to the athena tables.

7)  You can connect to Athena from Quicksight but it can only do one table at a time with no joins so its limited use I guess unless we join the tables outside quick sight.



*Additional Information*


1. ADAM DOCKER CONTAINER

This was run on Bare Metal Alienware Machine to reduce Cloud Costs. We used a readily avaiable cointainer from Docker Hub for this processing. 
In this, we took the VCF format Chromosome 22 files and converted them to the commonly used Parquet format

https://github.com/bigdatagenomics/adam
https://hub.docker.com/r/gelog/adam/

SPARK_VERSION 1.4.1
ADAM_VERSION 2.10 
ubuntu 14.04
JAVA_VERSION 7

Input = ALL.chr22.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz
Output = Chr22 Parquet files

2. UPLOAD TO S3 BUCKET

We uploaded files to S3 for processing in the cloud.

ADAM generated Parquet files
Population CSV Files
ClionVar Files 

3. RUN AWS GLUE TO INFER CHR22 PARQUET FILE METADATA

The file schema for the Chr22 adam generated parquet is nested and complex. It is hard to infer the schema. Furthermore the file corpus is large.
AWS Glue is an excellent tool for this and inferes the meta data for the files

root
 |-- variant: struct (nullable = true)
 |    |-- variantErrorProbability: integer (nullable = true)
 |    |-- contig: struct (nullable = true)
 |    |    |-- contigName: string (nullable = true)
 |    |    |-- contigLength: long (nullable = true)
 |    |    |-- contigMD5: string (nullable = true)
 |    |    |-- referenceURL: string (nullable = true)
 |    |    |-- assembly: string (nullable = true)
 |    |    |-- species: string (nullable = true)
 |    |    |-- referenceIndex: integer (nullable = true)
 |    |-- start: long (nullable = true)
 |    |-- end: long (nullable = true)
 |    |-- referenceAllele: string (nullable = true)
 |    |-- alternateAllele: string (nullable = true)
 |    |-- svAllele: struct (nullable = true)
 |    |    |-- type: string (nullable = true)
 |    |    |-- assembly: string (nullable = true)
 |    |    |-- precise: boolean (nullable = true)
 |    |    |-- startWindow: integer (nullable = true)
 |    |    |-- endWindow: integer (nullable = true)
 |    |-- isSomatic: boolean (nullable = true)
 |-- variantCallingAnnotations: struct (nullable = true)
 |    |-- variantIsPassing: boolean (nullable = true)
 |    |-- variantFilters: array (nullable = true)
 |    |    |-- element: string (containsNull = true)
 |    |-- downsampled: boolean (nullable = true)
 |    |-- baseQRankSum: float (nullable = true)
 |    |-- fisherStrandBiasPValue: float (nullable = true)
 |    |-- rmsMapQ: float (nullable = true)
 |    |-- mapq0Reads: integer (nullable = true)
 |    |-- mqRankSum: float (nullable = true)
 |    |-- readPositionRankSum: float (nullable = true)
 |    |-- genotypePriors: array (nullable = true)
 |    |    |-- element: float (containsNull = true)
 |    |-- genotypePosteriors: array (nullable = true)
 |    |    |-- element: float (containsNull = true)
 |    |-- vqslod: float (nullable = true)
 |    |-- culprit: string (nullable = true)
 |    |-- attributes: map (nullable = true)
 |    |    |-- key: string
 |    |    |-- value: string (valueContainsNull = true)
 |-- sampleId: string (nullable = true)
 |-- sampleDescription: string (nullable = true)
 |-- processingDescription: string (nullable = true)
 |-- alleles: array (nullable = true)
 |    |-- element: string (containsNull = true)
 |-- expectedAlleleDosage: float (nullable = true)
 |-- referenceReadDepth: integer (nullable = true)
 |-- alternateReadDepth: integer (nullable = true)
 |-- readDepth: integer (nullable = true)
 |-- minReadDepth: integer (nullable = true)
 |-- genotypeQuality: integer (nullable = true)
 |-- genotypeLikelihoods: array (nullable = true)
 |    |-- element: float (containsNull = true)
 |-- nonReferenceLikelihoods: array (nullable = true)
 |    |-- element: float (containsNull = true)
 |-- strandBiasComponents: array (nullable = true)
 |    |-- element: integer (containsNull = true)
 |-- splitFromMultiAllelic: boolean (nullable = true)
 |-- isPhased: boolean (nullable = true)
 |-- phaseSetId: integer (nullable = true)
 |-- phaseQuality: integer (nullable = true)


4. CREATE ATHENA TABLES following

We create ATHENA Tables for each of the following

clinvar (Annotations)
cr22_variant (Chr22 Variation File)
cr22population (Population File)

Amazon Athena is an interactive query service that makes it easy to analyze data in Amazon S3 using standard SQL. Athena is serverless, so there is no infrastructure to setup or manage, and you can start analyzing data immediately. You don’t even need to load your data into Athena, it works directly with data stored in S3.

Amazon Athena uses Presto with full standard SQL support and works with a variety of standard data formats, including CSV, JSON, ORC, Avro, and Parquet. Athena can handle complex analysis, including large joins, window functions, and arrays

Because Amazon Athena uses Amazon S3 as the underlying data store, it is highly available and durable with data redundantly stored across multiple facilities and multiple devices in each facility

These are the schemas for the athena tables

CREATE EXTERNAL TABLE `clinvar`(
  `alleleid` string, 
  `varianttype` string, 
  `hgvsname` string, 
  `geneid` string, 
  `genesymbol` string, 
  `hgncid` string, 
  `clinicalsignificance` string, 
  `clinsigsimple` string, 
  `lastevaluated` string, 
  `rsid` string, 
  `dbvarid` string, 
  `rcvaccession` string, 
  `phenotypeids` string, 
  `phenotypelist` string, 
  `origin` string, 
  `originsimple` string, 
  `assembly` string, 
  `chromosomeaccession` string, 
  `chromosome` string, 
  `startposition` int, 
  `endposition` int, 
  `referenceallele` string, 
  `alternateallele` string, 
  `cytogenetic` string, 
  `reviewstatus` string, 
  `numbersubmitters` string, 
  `guidelines` string, 
  `testedingtr` string, 
  `otherids` string, 
  `submittercategories` string)
ROW FORMAT DELIMITED 
  FIELDS TERMINATED BY '\t' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  's3://ccatestbucket/clinvar'
TBLPROPERTIES (
  'transient_lastDdlTime'='1550964315')


CREATE EXTERNAL TABLE `cr22_variant`(
  `variant` struct<variantErrorProbability:int,contig:struct<contigName:string,contigLength:bigint,contigMD5:string,referenceURL:string,assembly:string,species:string,referenceIndex:int>,start:bigint,end:bigint,referenceAllele:string,alternateAllele:string,svAllele:struct<type:string,assembly:string,precise:boolean,startWindow:int,endWindow:int>,isSomatic:boolean>, 
  `variantcallingannotations` struct<variantIsPassing:boolean,variantFilters:array<string>,downsampled:boolean,baseQRankSum:float,fisherStrandBiasPValue:float,rmsMapQ:float,mapq0Reads:int,mqRankSum:float,readPositionRankSum:float,genotypePriors:array<float>,genotypePosteriors:array<float>,vqslod:float,culprit:string,attributes:map<string,string>>, 
  `sampleid` string, 
  `sampledescription` string, 
  `processingdescription` string, 
  `alleles` array<string>, 
  `expectedalleledosage` float, 
  `referencereaddepth` int, 
  `alternatereaddepth` int, 
  `readdepth` int, 
  `minreaddepth` int, 
  `genotypequality` int, 
  `genotypelikelihoods` array<float>, 
  `nonreferencelikelihoods` array<float>, 
  `strandbiascomponents` array<int>, 
  `splitfrommultiallelic` boolean, 
  `isphased` boolean, 
  `phasesetid` int, 
  `phasequality` int)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat'
LOCATION
  's3://cr22-nn/'
TBLPROPERTIES (
  'transient_lastDdlTime'='1550964259')


CREATE EXTERNAL TABLE `cr22population`(
  `col0` string, 
  `col1` string, 
  `col2` string, 
  `col3` string)
ROW FORMAT DELIMITED 
  FIELDS TERMINATED BY ',' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  's3://cr22population/'
TBLPROPERTIES (
  'CrawlerSchemaDeserializerVersion'='1.0', 
  'CrawlerSchemaSerializerVersion'='1.0', 
  'UPDATED_BY_CRAWLER'='cr22_population_crawler', 
  'areColumnsQuoted'='false', 
  'averageRecordSize'='23', 
  'classification'='csv', 
  'columnsOrdered'='true', 
  'compressionType'='none', 
  'delimiter'=',', 
  'objectCount'='1', 
  'recordCount'='2506', 
  'sizeKey'='57659', 
  'typeOfData'='file')

6. CREATE VIEWS IN ATHENA 

CREATE OR REPLACE VIEW variant_reduced AS 
SELECT
  "variant"."referenceallele"
, "variant"."alternateallele"
, "variant"."end" "endposition"
, "variant"."start" "startposition"
, "sampleid"
, 22 "chromosome"
FROM
  cr22.cr22_variant

5. QUERY TABLES THROUGH ATHENA

select distinct cv.phenotypelist, cv.clinicalsignificance from  
cr22.variant_reduced sv
JOIN cr22.clinvar cv
ON cast(sv.chromosome as varchar) = cv.chromosome
    AND sv.startposition = cv.startposition - 1
    AND sv.endposition = cv.endposition
    AND sv.referenceallele = cv.referenceallele
    AND sv.alternateallele = cv.alternateallele
    AND cv.clinicalsignificance = 'drug response'
limit 10;

6. USE SAGEMAKER TO CONNECT TO ATHENA TABLES AND USE PYTHON CODE AND LIBRARIES

7. RUN ML ALGORITHMS ON SAGEMAKER
Use sklearn and other ML libraries
