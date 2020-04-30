
#!/usr/bin/env bash
docker build -t sqlserver-metadata-generator .
docker tag sqlserver-metadata-generator mesmacosta/sqlserver-metadata-generator:stable
docker push mesmacosta/sqlserver-metadata-generator:stable
