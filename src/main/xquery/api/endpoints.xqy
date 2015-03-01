xquery version "1.0-ml";

module namespace endpoints="http://marklogic.com/appservices/endpoints";

import module namespace rest="http://marklogic.com/appservices/rest" at "/ml-rest-lib/rest.xqy";

declare default function namespace "http://www.w3.org/2005/xpath-functions";

declare option xdmp:mapping "false";

declare variable $endpoints:ENDPOINTS as element(rest:options) :=
  <options xmlns="http://marklogic.com/appservices/rest">
     {(: Run the unit tests if requested :)}
     <request uri="^/tests(/.*)?$" endpoint="/test/default.xqy" user-params="allow">
     </request>

    {(: Run the unit tests if requested :)}
     <request uri="^/test(/.*)?$" endpoint="/test/default.xqy" user-params="allow">
     </request>

     {(: Dispatch to feed :)}
     <request uri="^/marklogic-tv/api/programmes.*/?" endpoint="/api/controllers/programmes-controller.xqy" user-params="allow">
       <http method="GET"/>
     </request>

    <request uri="^/marklogic-tv/api/genres.*/?" endpoint="/api/controllers/genres-controller.xqy" user-params="allow">
      <http method="GET"/>
    </request>

    <request uri="^/marklogic-tv/api/admin/programmes.*/?" endpoint="/api/admin/controllers/programmes-controller.xqy" user-params="allow">
      <http method="GET"/>
      <http method="DELETE"/>
      <http method="POST"/>
    </request>

    <request uri="^/marklogic-tv/api/admin/media-play.*/?" endpoint="/api/admin/controllers/media-play-controller.xqy" user-params="allow">
      <http method="POST"/>
    </request>

    {(: Serve /default.xqy by default so that the main page will be displayed :)}
    <request uri="^/xqtest/resources/*" user-params="ignore">
    </request>

   {(: Do not change this endpoint :)}
   <request uri="^/*" endpoint="/forbidden.xqy" user-params="ignore"/>

  </options>;

declare function endpoints:doc-exists(
  $uri as xs:string,
  $func as element(rest:function))
as xs:boolean
{
  doc-available($uri)
};

declare function endpoints:options()
as element(rest:options)
{
  let $check := rest:check-options($ENDPOINTS)
  return
    if (empty($check))
    then
      $ENDPOINTS
    else
      error(xs:QName("ERROR"), "Options are not valid in endpoints.xqy")
};

declare function endpoints:request(
  $module as xs:string)
as element(rest:request)?
{
  ($ENDPOINTS/rest:request[@endpoint = $module])[1]
};
