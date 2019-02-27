-- Verify the MRP is process
SELECT inst_id, process, status mrp_stat, thread sequence block FROM gv$managed_standby where process LIKE 'MRP%' ;