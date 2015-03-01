#!/bin/sh

read  -p "Host ip: " ip

read  -p "XDBC Server port: " port

read  -p "Admin username: " username

read -s -p "Admin password: " password

working_dir=$(dirname "$BASH_SOURCE")

pushd $working_dir/..
CODE_PATH=$(pwd -P)
popd

echo "Deploying code from directory : $CODE_PATH"

${working_dir}/mlcp-Hadoop2-1.3-1/bin/mlcp.sh import -host "${ip}" -port "${port}" -username "${username}" -password "${password}" -input_file_path ../xquery -output_uri_replace "$CODE_PATH/xquery,'/marklogic-tv'" -mode local