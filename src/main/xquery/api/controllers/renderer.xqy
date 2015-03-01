xquery version "1.0-ml";

module namespace renderer = "http://www.marklogic.co.uk/marklogic-tv/api/controllers/renderer";

import module namespace json="http://marklogic.com/xdmp/json"
at "/MarkLogic/json/json.xqy";

declare default element namespace "http://marklogic.com/xdmp/json/basic";
declare namespace d="http://marklogic.com/xdmp/json/basic";

declare option xdmp:mapping "false";

declare variable $XML as xs:string := "application/xml";
declare variable $XML-UTF8 as xs:string := "application/xml;charset=utf-8";
declare variable $JSON as xs:string := "application/json";
declare variable $JSON-UTF8 as xs:string := "application/json;charset=utf-8";

declare function render($res as item()*) as item()* {
  if ( fn:contains(xdmp:get-request-header("accept", $JSON), $XML) ) then
    (
      xdmp:set-response-content-type($XML-UTF8),
      <result type="object">
        <total type="string">{$res/total/fn:data(.)}</total>
        {$res/paging}
        <items type="array">{$res/items/json/*}</items>
      </result>
    )
  else
    (xdmp:set-response-content-type($JSON-UTF8),
    '{ "result":' ||json:transform-to-json($res)|| '}'
    )

};
