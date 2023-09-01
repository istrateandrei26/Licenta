#!/bin/bash

# Wait for SQL Server to become healthy
while [ $(/opt/mssql-tools/bin/sqlcmd -h -1 -t 1 -U sa -P password@12345# -Q "SELECT 1" > /dev/null; echo $?) -ne 0 ]
do
  echo "Waiting for SQL Server to become healthy..."
  sleep 1
done


echo "[+] SQL Server successfully started..."