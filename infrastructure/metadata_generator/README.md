# sqlserver-metadata-generator

To test some SQLServer capabilities, it’s good to have a good number of tables with different complex column types. This script generates random metadata for SQLServer.

## Activate your virtualenv if it’s not up
```bash
pip install --upgrade virtualenv
python3 -m virtualenv --python python3 env
source ./env/bin/activate
```

## Install the requirements for the metadata generator
```bash
pip install -r requirements.txt
```

# Install ODBC Driver 17 for SQL Server
https://docs.microsoft.com/en-us/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server?view=sql-server-2017

## Run the script
```bash
python metadata_generator.py
```

## Developer environment

### Install and run Yapf formatter

```bash
pip install --upgrade yapf

# Auto update files
yapf --in-place metadata_generator.py

# Show diff
yapf --diff metadata_generator.py

# Set up pre-commit hook
# From the root of your git project.
curl -o pre-commit.sh https://raw.githubusercontent.com/google/yapf/master/plugins/pre-commit.sh
chmod a+x pre-commit.sh
mv pre-commit.sh .git/hooks/pre-commit
```

### Install and run Flake8 linter

```bash
pip install --upgrade flake8
flake8 metadata_generator.py
```
