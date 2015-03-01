xquery version "1.0-ml";

import module namespace rest = "http://marklogic.com/appservices/rest" at "/ml-rest-lib/rest.xqy";

declare option xdmp:mapping "false";

declare variable $ENDPOINTS as element(rest:options) :=
  <options xmlns="http://marklogic.com/appservices/rest">
    <request uri="^/host-status" endpoint="/api/health-check.xqy?check=host" user-params="ignore"/>
    <request uri="^/cluster-status" endpoint="/api/health-check.xqy?check=cluster" user-params="ignore"/>
    <request uri="^/fail-finder" endpoint="/api/failfinder.xqy" user-params="ignore"/>
    <!-- everything else falls back to giving the basic host health check -->
    <request uri="^/*" endpoint="/api/health-check.xqy?check=host" user-params="ignore"/>
  </options>
;

rest:rewrite($ENDPOINTS)

