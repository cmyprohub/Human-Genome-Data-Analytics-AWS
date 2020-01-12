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
  'transient_lastDdlTime'='1551025053')