# docker build -t sqlserver-metadata-generator .
FROM python:3.7

# install FreeTDS and dependencies
RUN apt-get update \
 && apt-get install unixodbc -y \
 && apt-get install unixodbc-dev -y \
 && apt-get install --reinstall build-essential -y

# Debian 10 ODBC DRIVER
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update
RUN ACCEPT_EULA=Y apt-get install msodbcsql17

WORKDIR /lib
COPY requirements.txt .
RUN pip install -r requirements.txt

WORKDIR /app

# Copy project files (see .dockerignore).
COPY . .

ENTRYPOINT ["python", "metadata_generator.py"]
