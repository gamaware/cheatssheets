# Manually set environment variables
export ORACLE_SID=+ASM1
export ORACLE_HOME=/u01/app/12.2.0.1/grid
export PATH=$ORACLE_HOME/bin:$PATH
export NLS_LANG=American_America.AL32UTF8

# Check Environment Variables
env | grep ORACLE 

# Check alertlog location
find / -name alert_*.log 2>/dev/null

# Determine where the Oracle home for a given database is located (Linux)
cat /etc/oratab

# Determine where the Oracle home for a given database is located (SunOS)
cat /var/opt/oracle/oratab

# Agent operations
$GRID_ORACLE_HOME/bin/emctl status agent
$GRID_ORACLE_HOME/bin/emctl reload agent
$GRID_ORACLE_HOME/bin/emctl stop agent
$GRID_ORACLE_HOME/bin/emctl start agent

# Upload Files to a Specific SR
curl -T "{ORA7445kk_20181210142538_COM_1.zip}" -u alex.garcia.m@oracle.com "https://transport.oracle.com/upload/issue/3-18932937601/" -o log.txt -k