# Display 5 biggest files
du -sh * | sort -rh | head -5

# Check usage on diag
find /* -name diag -exec du -sh {} \;

# Release space on /u02 filesystem by compressing/deleting listener log files
find . -name "log_*.xml" -mtime +3 -exec gzip -f {} \;
find . -name "log_*.xml.gz" -mtime +4 -exec rm -rf {} \;

# Release space on /u02 filesystem by compressing tracefiles 
find /u02/* -name "*.tr[c|m]" -mtime +7 -exec gzip -f {} \;
find /u02/* -name "*.trc" -mtime +7 -exec gzip -f {} \;
find /u02/* -name "*.trm" -mtime +7 -exec gzip -f {} \;

# Release space on /u02 filesystem by deleting tracefiles 
find /u02/* -name "*.tr[c|m].gz" -mtime +7 -exec rm -rf {} \;
find /u02/* -name "*.trc.gz" -mtime +10 -exec rm -rf {} \;
find /u02/* -name "*.trm.gz" -mtime +10 -exec rm -rf {} \;

# Display usage on /u02 filesystem by checking audit files
find /u02/* -type f \( -name "*.aud" \) -mtime +7 -exec ls {} \;|wc -l

# Release space on /u02 filesystem by compressing audit files
find /u02/* -type f -name "*.aud" -mtime +7 -exec gzip -rf {} \;

# Release space on /u02 filesystem by deleting audit files
find /u02/* -type f -name "*.aud.gz" -mtime +7 -exec rm -rf {} \;

# Experimental compression on /u02 filesystem
find /u02/* -type f \( -name "*.tr[c|m]" -o -name "*.trm" -o -name "*.log" \) -mtime +10 -exec gzip -f {} \;
export today=`date | awk '{print $3"_"$2"_"$NF"_"$4}'` ; for i in `find /u01/app/oracle/diag/rdbms/dinteg/dinteg?/trace -type f -name "*.tr[c|m]" -size +100M` ; do ls -lh $i >>/tmp/100M.txt; cp -p $i $i.$today ; cat /dev/null > $i ; gzip $i.$today; ls -lh $i* >> /tmp/100M.txt ; done