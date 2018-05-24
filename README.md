docker-oracle-xe-11g-centos
============================

Oracle Express Edition 11g Release 2 on CentOS 7

Based on [wnameless/docker-oracle-xe-11g](https://github.com/wnameless/docker-oracle-xe-11g) which is built on Ubuntu.
The key difference is that this image does not run as root and instead uses the oracle (uid=1000) user. The intention is to allow the container to run in Openshift without the need for root.

## Installation
```
docker pull andyrbell/oracle-xe-11g-centos
```

## Quick Start

Run with 1521 port opened:
```
docker run -d -p 1521:1521 andyrbell/oracle-xe-11g-centos
```

Run this, if you want the database to be connected remotely:
```
docker run -d -p 1521:1521 -e ORACLE_ALLOW_REMOTE=true andyrbell/oracle-xe-11g-centos
```

For performance concern, you may want to disable the disk asynch IO:
```
docker run -d -p 1521:1521 -e ORACLE_DISABLE_ASYNCH_IO=true andyrbell/oracle-xe-11g-centos
```

For XDB user, run this:
```
docker run -d -p 1521:1521 -p 8080:8080 -e ORACLE_ENABLE_XDB=true andyrbell/oracle-xe-11g-centos
```

Check if localhost:8080 work
```
curl -XGET "http://localhost:8080"
```
You will show
```
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
<HTML><HEAD>
<TITLE>401 Unauthorized</TITLE>
</HEAD><BODY><H1>Unauthorized</H1>
</BODY></HTML>
```

```
# Login http://localhost:8080 with following credential:
username: XDB
password: xdb
```

By default, the password verification is disable(password never expired)<br/>
Connect database with following setting:
```
hostname: localhost
port: 1521
sid: xe
username: system
password: oracle
```

Password for SYS & SYSTEM
```
oracle
```

Support custom DB Initialization
```
# Dockerfile
FROM andyrbell/oracle-xe-11g-centos

ADD init.sql /docker-entrypoint-initdb.d/
```
