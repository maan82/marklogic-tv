#!/bin/sh

read  -p "MarkLogic host IP: " ip

read  -p "MarkLogic Admin username: " username

read -s -p "MarkLogic Admin password: " password

echo "Setting up MarkLogic..."

curl  -X POST --digest -u "${username}:${password}" -H "Content-type: application/xml" -d @ml-tv-db.xml "http://${ip}:8002/manage/v2/packages?pkgname=ml-tv-db-package"

curl -i -X POST --data-binary @/dev/null --digest -u "${username}:${password}"  -H "Content-type: application/xml" "http://${ip}:8002/manage/v2/packages/ml-tv-db-package/install"

curl  -X POST --digest -u "${username}:${password}" -H "Content-type: application/xml" -d @ml-tv-xquery-db.xml "http://${ip}:8002/manage/v2/packages?pkgname=ml-tv-xquery-db-package"

curl -i -X POST --data-binary @/dev/null --digest -u "${username}:${password}"  -H "Content-type: application/xml" "http://${ip}:8002/manage/v2/packages/ml-tv-xquery-db-package/install"

curl  -X POST --digest -u "${username}:${password}" -H "Content-type: application/xml" -d @ml-tv-xdbc-server.xml "http://${ip}:8002/manage/v2/packages?pkgname=ml-tv-xdbc-server-package"

curl -i -X POST --data-binary @/dev/null --digest -u "${username}:${password}"  -H "Content-type: application/xml" "http://${ip}:8002/manage/v2/packages/ml-tv-xdbc-server-package/install"

curl  -X POST --digest -u "${username}:${password}" -H "Content-type: application/xml" -d @ml-tv-server.xml "http://${ip}:8002/manage/v2/packages?pkgname=ml-tv-server-package"

curl -i -X POST --data-binary @/dev/null --digest -u "${username}:${password}"  -H "Content-type: application/xml" "http://${ip}:8002/manage/v2/packages/ml-tv-server-package/install"


