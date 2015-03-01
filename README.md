 README
========

## Requisites
- MarkLogic 7
- Java
- Gradle
- Preferred IDE/Text editor
- Internet connection

## Code structure
- "<PROJECT_HOME_DIRECTORY>/src/main/java"  Java code
- "<PROJECT_HOME_DIRECTORY>/src/main/test"  Java tests code
- "<PROJECT_HOME_DIRECTORY>/src/main/xquery"  Xquery modules
- "<PROJECT_HOME_DIRECTORY>/src/main/xquery/test"  Xquery tests
- "<PROJECT_HOME_DIRECTORY>/src/main/scripts"  Setup, deployment and test data scripts


## Setup
cd to scripts directory
- `$ cd src/main/scripts`

"setup.sh" script sets up MarkLogic HTTP, XDBC server and database. By default it will setup HTTP server on port 9801, XDBC server on port 9802.
To change port for HTTP server, change port element value and name element value in src/main/scripts/ml-tv-server.xml
To change port for XDBC server, change port element value and name element value in src/main/scripts/ml-tv-xdbc-server.xml
Run below command from terminal to setup and enter the information it asks.
- `$ ./setup.sh`

If you have changed HTTP port than change "marklogic.api.port" property in src/main/resources/application.properties

Change direcotry to project home directory(marklogic-tv)
- `$ cd <PROJECT_HOME_DIRECTORY>`

To start java application run below
- `$ ./gradlew test`: run tests
- `$ ./gradlew build`: builds the project
- `$ java -jar build/libs/marklogic-tv-0.1.0.jar`: runs the server

For user application point your browser to [http://localhost:8080/app/index.html](http://localhost:8080/app/index.html)
For admin application point your browser to [http://localhost:8080/admin/load.html](http://localhost:8080/admin/load.html)

To generate some test data, cd to scripts directory and run test-data.sh as below. Enter the information it asks
- `$ cd src/main/scripts`
- `$ ./test-data.sh`

To setup test environment on MarkLogic run setup-test.sh as below. By default it will setup HTTP server on port 9803.
To change port for test HTTP server, change port element value and name element value in src/main/scripts/ml-tv-test-server.xml
- `$ cd src/main/scripts`
- `$ ./setup-test.sh`

To run xquery tests point your browser to [http://localhost:9803/test](http://localhost:9803/test)

## Teardown packages
Setup scripts create packages in MarkLogic.To remove these packages run below and enter the information it asks
- `$ cd src/main/scripts`
- `$ ./teardown-packages.sh`
- `$ ./teardown-test-packages.sh`




