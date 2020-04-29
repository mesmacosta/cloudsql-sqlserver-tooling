# cloudsql-sqlserver-tooling

Scripts with the goal to enable easy usage of some SQLServer operations.

## INIT database
```bash
./init-db.sh
```

## Creating Schemas and Tables in SQLServer
```bash
./connect-db.sh
```
Provide your password when prompted, then execute:
```bash
use "test-db";
CREATE SCHEMA MY_SCHEMA;
CREATE TABLE MY_SCHEMA.MY_TABLE (name INT, address TEXT);
exit
```
If you receive errors please run:
```bash
sudo pip install mssql-cli --ignore-installed six
```
To update the sql server driver used by gcloud.

## Clean up SQLServer Schemas and Tables
```bash
./cleanup-db.sh
```

## Delete the SQLServer database
```bash
./delete-db.sh
```

