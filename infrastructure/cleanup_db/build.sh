
#!/usr/bin/env bash
docker build -t sqlserver-db-cleaner .
docker tag sqlserver-db-cleaner mesmacosta/sqlserver-db-cleaner:stable
docker push mesmacosta/sqlserver-db-cleaner:stable
