CREATE EXTERNAL TABLE `cr22_variant`(
  `variant` struct<variantErrorProbability:int,contig:struct<contigName:string,contigLength:bigint,contigMD5:string,referenceURL:string,assembly:string,species:string,referenceIndex:int>,start:bigint,`end`:bigint,referenceAllele:string,alternateAllele:string,svAllele:struct<type:string,assembly:string,precise:boolean,startWindow:int,endWindow:int>,isSomatic:boolean>, 
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
  'transient_lastDdlTime'='1551025007')