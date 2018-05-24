#!/bin/bash

. /u01/app/oracle/product/11.2.0/xe/bin/oracle_env.sh

/u01/app/oracle/product/11.2.0/xe/config/scripts/startdb.sh

if [ "$ORACLE_ENABLE_XDB" = true ]; then
  echo "ALTER USER XDB ACCOUNT UNLOCK;" | sqlplus -s SYSTEM/oracle
  echo "ALTER USER XDB IDENTIFIED BY xdb;" | sqlplus -s SYSTEM/oracle
fi

if [ "$ORACLE_ALLOW_REMOTE" = true ]; then
  echo "alter system disable restricted session;" | sqlplus -s SYSTEM/oracle
fi

if [ "$ORACLE_DISABLE_ASYNCH_IO" = true ]; then
  echo "ALTER SYSTEM SET disk_asynch_io = FALSE SCOPE = SPFILE;" | sqlplus -s SYSTEM/oracle
  /u01/app/oracle/product/11.2.0/xe/config/scripts/stopdb.sh
  /u01/app/oracle/product/11.2.0/xe/config/scripts/startdb.sh
fi

for f in /docker-entrypoint-initdb.d/*; do
  case "$f" in
    *.sh)     echo "$0: running $f"; . "$f" ;;
    *.sql)    echo "$0: running $f"; echo "exit" | /u01/app/oracle/product/11.2.0/xe/bin/sqlplus "SYS/oracle" AS SYSDBA @"$f"; echo ;;
    *)        echo "$0: ignoring $f" ;;
  esac
  echo
done
