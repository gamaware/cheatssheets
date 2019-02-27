# CRS Commands
# Kernel Parameters 
# before attempting to stop crs on any node, make sure that the kernel parameters are correctly set, to verify you can issue this command 
cat /etc/security/limits 

# Checking Cluster/CRS Services 
# crs help
crsctl -help

# Check cluster on all nodes 
crsctl check cluster -all
************************************************************** 
u284: 
CRS-4537: Cluster Ready Services is online 
CRS-4529: Cluster Synchronization Services is online 
CRS-4533: Event Manager is online 
************************************************************** 
u498: 
CRS-4537: Cluster Ready Services is online 
CRS-4529: Cluster Synchronization Services is online 
CRS-4533: Event Manager is online 
************************************************************** 

# Check crs on one node 
crsctl check cluster
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online

crsctl check crs
CRS-4638: Oracle High Availability Services is online
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online

 # Check cluster resources 
crsctl status resource -t -init
crsctl stat res -t -init
NAME           TARGET  STATE        SERVER                   STATE_DETAILS        
-------------------------------------------------------------------------------- 
Cluster Resources F
-------------------------------------------------------------------------------- 
ora.asm 
      1        ONLINE  ONLINE       u284                     Started              
ora.cluster_interconnect.haip 
      1        ONLINE  ONLINE       u284                                          
ora.crf 
      1        ONLINE  ONLINE       u284                                          
ora.crsd 
      1        ONLINE  ONLINE       u284                                          
ora.cssd 
      1        ONLINE  ONLINE       u284                                          
ora.cssdmonitor 
      1        ONLINE  ONLINE       u284                                          
ora.ctssd 
      1        ONLINE  ONLINE       u284                     OBSERVER             
ora.diskmon 
      1        OFFLINE OFFLINE                                                    
ora.drivers.acfs 
      1        ONLINE  ONLINE       u284                                          
ora.evmd 
      1        ONLINE  ONLINE       u284                                          
ora.gipcd 
      1        ONLINE  ONLINE       u284                                          
ora.gpnpd 
      1        ONLINE  ONLINE       u284                                          
ora.mdnsd 
      1        ONLINE  ONLINE       u284             

# Check databases running on nodes
crsctl stat res -t -w "NAME co .db"
--------------------------------------------------------------------------------
NAME           TARGET  STATE        SERVER                   STATE_DETAILS       
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.infradb.db
      1        ONLINE  ONLINE       rdp2dbadm01              Open                
      2        ONLINE  ONLINE       rdp2dbadm02              Open                
ora.pribsp1.db
      1        ONLINE  ONLINE       rdp2dbadm01              Open                
      2        ONLINE  ONLINE       rdp2dbadm02              Open  

# Check listeners running on nodes
crsctl stat res -t -w "NAME co .lsn"
--------------------------------------------------------------------------------
NAME TARGET STATE SERVER STATE_DETAILS
--------------------------------------------------------------------------------
Local Resources
--------------------------------------------------------------------------------
ora.LISTENER.lsnr
ONLINE ONLINE metfdbadm02
ora.LISTENER_IB.lsnr
ONLINE ONLINE metfdbadm02
ora.LISTENER_IDENT_CAP.lsnr
ONLINE ONLINE metfdbadm02
ora.LISTENER_IDENT_DES.lsnr
ONLINE ONLINE metfdbadm02
ora.LISTENER_IDENT_QUA.lsnr
ONLINE ONLINE metfdbadm02
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.LISTENER_SCAN1.lsnr
1 ONLINE ONLINE metfdbadm02
ora.LISTENER_SCAN2.lsnr
1 ONLINE ONLINE metfdbadm02
ora.LISTENER_SCAN3.lsnr
1 ONLINE ONLINE metfdbadm02
orarom@metfdbadm02:~$ date;hostname;uname
Monday, October 5, 2015 08:35:09 AM CDT
metfdbadm02
SunOS

# Checking Databases, Instances and NodeApps availability 
# Check database status 
srvctl status database -d DWHHIS
Instance DWHHIS1 is running on node exa02dbadm01
Instance DWHHIS2 is running on node exa02dbadm02
Instance DWHHIS3 is running on node exa02dbadm03
Instance DWHHIS4 is running on node exa02dbadm04
Instance DWHHIS5 is running on node exa02dbadm05
Instance DWHHIS6 is running on node exa02dbadm06
Instance DWHHIS7 is running on node exa02dbadm07

# Check One instance status 
srvctl status instance -d DWHHIS -i DWHHIS1
Instance DWHHIS1 is running on node exa02dbadm01

# Stopping Databases, Instances and NodeApps 
# Stop database 
srvctl stop database -d DWHHIS 

# Stop just one instance 
srvctl stop instance -d DWHHIS -i DWHHIS1 

# Stopping CRS, Cluster, ASM 
# Before attempting to stop cluster or crs, always make sure that all databases are properly shutdown, refer to stop database section before continuing 
# Stop crs on all nodes 
crsctl stop cluster -all 

# Stop crs on one node 
crsctl stop crs  

# Sometimes is necessary to use force option
crsctl stop crs -f 

# Starting CRS, Cluster, ASM 
# start crs on all nodes 
crsctl start cluster -all 

# start crs on one node 
crsctl start crs  

# Sometimes is necessary to use force option
crsctl start crs -f 

# Workaround in case of issues starting or stopping CRS 
# Oracle References
# KA 1016967
# http://docs.oracle.com/database/121/CWADD/crsref.htm#CWADD91142
# http://docs.oracle.com/cd/E18283_01/rac.112/e16794/crsref.htm

# Other References
# http://praveensblogonoracle.blogspot.com/2009/03/basic-crs-and-srvctl-commands.html
# http://oracledbabay.blogspot.com/2012/11/crsctl-commands-in-oracle-rac-10g.html
# http://www.dba-oracle.com/t_crs_srvctl_rac_os_commands.htm