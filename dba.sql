
-- Check DB Version
SELECT banner from v$version;

-- Check Connection ID
SELECT name, cdb, con_id FROM v$database; 

-- Check Pluggable Databases Status
COLUMN con_id FORMAT 999
COLUMN name FORMAT A10
SELECT name, con_id FROM open_mode FROM v$pdbs;

-- Open Pluggable Database
ALTER PLUGGABLE DATABASE PDB1 OPEN;

-- Switch to a PDB
ALTER SESSION SET CONTAINER = SCHQA625;

-- Check alertlog location
SET linesize 200 COLUMN value format a300
SELECT value FROM v$diag_info WHERE name='Diag Trace';

-- Check suggested action on outstanding alerts
SELECT reason FROM dba_outstanding_alerts;

-- Display OEM Threshold values on tablespaces
SET pagesize 500
SET linesize 200 COLUMN INSTANCE_NAME
FOR a15d COLUMN OBJECT_NAME
FOR a25 COLUMN metrics_name
FOR a50 COLUMN warning_value
FOR a15 COLUMN critical_value
FOR a10 COLUMN consecutive_occurrences a10
SELECT INSTANCE_NAME, OBJECT_NAME, metrics_name, warning_value, critical_value, consecutive_occurrences FROM DBA_THRESHOLDS WHERE metrics_name LIKE '%Tablespace%';

-- Check database status
SET linesize 512 col host_name
FOR a35
SELECT db_unique_name,
       name,
       open_mode,
       DATABASE_ROLE,
       TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS') "TIME",
       TO_CHAR(STARTUP_TIME, 'DD-MON-YYYY HH24:MI:SS') "STARTUP_TIME",
       INSTANCE_NAME,
       HOST_NAME,
       STATUS
FROM GV$DATABASE,
     GV$INSTANCE
WHERE GV$DATABASE.inst_id=GV$INSTANCE.inst_id;

-- Validate Tablespace Usage
COLUMN name format a10
SELECT a.tablespace_name,
       Round(a.totsize / 1024 / 1024, 0) "Tot Size (MB)",
       Round(Nvl(b.used, 0) / 1024 / 1024, 0) "Used (MB)",
       100 - Round(((a.totsize - Nvl(b.used, 0)) / a.totsize) * 100, 0) "% Used",
       Round(((a.totsize - Nvl(b.used, 0)) / a.totsize) * 100, 0) "% Free"
FROM
  (SELECT tablespace_name,
          SUM(bytes) totsize
   FROM dba_data_files
   GROUP BY tablespace_name) a,

  (SELECT tablespace_name,
          SUM(bytes) used
   FROM dba_segments
   GROUP BY tablespace_name) b
WHERE a.tablespace_name = b.tablespace_name (+)
  AND a.tablespace_name = 'NC_GROUP_DORETL_TS';
  
-- Validate Tablespace Usage (Alternative)
SELECT * FROM dba_tablespace_usage_metrics WHERE tablespace_name LIKE 'NC_GROUP_DORETL_TS';

-- Confirm Datafiles on Diskgroup
SET lines 180 col file_name
FOR a70 col tablespace_name
FOR a25 col autoextensible
FOR a10 col SIZE
FOR 99999999999999999999 col maxsize
FOR 99999999999999999999
SELECT file_name,
       tablespace_name,
       bytes "SIZE",
       maxbytes "MAXSIZE",
       increment_by "INCREMENT_BY",
       autoextensible
FROM dba_data_files
WHERE tablespace_name LIKE 'NC_GROUP_DORETL_TS'
ORDER BY file_name;

-- Verify available Diskgroups space
SET lines 180 
SELECT name, TYPE, Round(100 - (usable_file_mb / total_mb * 100), 2) "Used % of Safely Usable", free_mb "Free % of Safely Usable" FROM v$asm_diskgroup_stat;

-- Verify previously added datafiles
SELECT file_id,
       'ALTER TABLESPACE ' || tablespace_name || ' ADD DATAFILE ''' || SUBSTR(file_name, 1, INSTR(file_name, '/', 1, 1)-1) || ''' SIZE ' || MAXBYTES || ' AUTOEXTEND ON NEXT ' || ROUND(INCREMENT_BY * P.VALUE) || ' MAXSIZE ' || MAXBYTES || ';' AS "DDL"
FROM dba_data_files,

  (SELECT value
   FROM v$parameter
   WHERE name = 'db_block_size') P
WHERE tablespace_name = '&TABLESPACE_NAME'
ORDER BY file_id;