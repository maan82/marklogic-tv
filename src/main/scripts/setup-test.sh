#!/bin/sh

read  -p "MarkLogic host IP: " ip

read  -p "MarkLogic Admin username: " username

read -s -p "MarkLogic Admin password: " password

working_dir=$(dirname "$BASH_SOURCE")

pushd $working_dir/..
CODE_PATH=$(pwd)
popd

echo "Setting up test env in MarkLogic..."

curl  -X POST --digest -u "${username}:${password}" -H "Content-type: application/xml" -d @ml-tv-test-db.xml "http://${ip}:8002/manage/v2/packages?pkgname=ml-tv-test-db-package"

curl -i -X POST --data-binary @/dev/null --digest -u "${username}:${password}"  -H "Content-type: application/xml" "http://${ip}:8002/manage/v2/packages/ml-tv-test-db-package/install"

sed "s#{{ROOT}}#$CODE_PATH/xquery#g" ml-tv-test-server.xml > ml-tv-test-out-server.xml

curl  -X POST --digest -u "${username}:${password}" -H "Content-type: application/xml" -d @ml-tv-test-out-server.xml "http://${ip}:8002/manage/v2/packages?pkgname=ml-tv-test-server-package"

curl -i -X POST --data-binary @/dev/null --digest -u "${username}:${password}"  -H "Content-type: application/xml" "http://${ip}:8002/manage/v2/packages/ml-tv-test-server-package/install"


