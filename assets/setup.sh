#!/bin/bash

yum install -y libaio net-tools bc &&

cat /assets/oracle-xe-11.2.0-1.0.x86_64.rpm.parta* > /assets/oracle-xe-11.2.0-1.0.x86_64.rpm &&

yum install -y /assets/oracle-xe-11.2.0-1.0.x86_64.rpm &&

. /u01/app/oracle/product/11.2.0/xe/bin/oracle_env.sh

mv /assets/init.ora ${ORACLE_HOME}/config/scripts &&
mv /assets/initXETemp.ora ${ORACLE_HOME}/config/scripts &&

LISTENER_ORA=${ORACLE_HOME}/network/admin/listener.ora &&
TNSNAMES_ORA=${ORACLE_HOME}/network/admin/tnsnames.ora &&

sed -i -e "s/%hostname%/0.0.0.0/g" -e "s/%port%/1521/g" "${LISTENER_ORA}" &&
sed -i -e "s/%hostname%/0.0.0.0/g" -e "s/%port%/1521/g" "${TNSNAMES_ORA}" &&

sed -i "s/xsetroot/#xsetroot/g" ${ORACLE_HOME}/config/scripts/startdb.sh
sed -i "s/xsetroot/#xsetroot/g" ${ORACLE_HOME}/config/scripts/stopdb.sh

printf 8080\\n1521\\noracle\\noracle\\ny\\n | /etc/init.d/oracle-xe configure &&

echo ". ${ORACLE_HOME}/bin/oracle_env.sh" >> /etc/bashrc &&

# copy bash initialisation scripts to the oracle user's home dir
cp /etc/skel/.bash* /u01/app/oracle &&
chown oracle. /u01/app/oracle/.bash* &&

# Install startup script for container
mv /assets/startup.sh /usr/sbin/startup.sh &&
chmod +x /usr/sbin/startup.sh &&

# Remove installation files
rm -rf /assets &&
yum clean all &&
rm -rf /var/cache/yum &&

# Create initialization script folders
mkdir /docker-entrypoint-initdb.d

# Disable Oracle password expiration
echo "ALTER PROFILE DEFAULT LIMIT PASSWORD_VERIFY_FUNCTION NULL;" | sqlplus -s SYSTEM/oracle
echo "alter profile DEFAULT limit password_life_time UNLIMITED;" | sqlplus -s SYSTEM/oracle
echo "alter user SYSTEM identified by oracle account unlock;" | sqlplus -s SYSTEM/oracle

exit $?
