#!/bin/bash
. /u01/app/oracle/product/11.2.0/xe/bin/oracle_env.sh
echo "select 1 from dual;" | sqlplus -s SYSTEM/oracle
