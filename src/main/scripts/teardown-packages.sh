#!/bin/sh

read  -p "MarkLogic host IP: " ip

read  -p "MarkLogic Admin username: " username

read -s -p "MarkLogic Admin password: " password

echo "Tearing down packages..."

curl -i  -X DELETE --digest -u "${username}:${password}" -H "Content-type: application/xml" "http://${ip}:8002/manage/v2/packages/ml-tv-db-package"

curl -i -X DELETE --digest -u "${username}:${password}" -H "Content-type: application/xml" "http://${ip}:8002/manage/v2/packages/ml-tv-xquery-db-package"

curl -i -X DELETE --digest -u "${username}:${password}" -H "Content-type: application/xml" "http://${ip}:8002/manage/v2/packages/ml-tv-server-package"

curl -i -X DELETE --digest -u "${username}:${password}" -H "Content-type: application/xml" "http://${ip}:8002/manage/v2/packages/ml-tv-xdbc-server-package"
