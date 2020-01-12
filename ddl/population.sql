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
  'transient_lastDdlTime'='1551024783', 
  'typeOfData'='file')