xquery version "1.0-ml";

module namespace base-repository = "http://www.marklogic.co.uk/marklogic-tv/api/repository/base-repository";

import module namespace json="http://marklogic.com/xdmp/json" at "/MarkLogic/json/json.xqy";
import module namespace request="http://www.marklogic.co.uk/marklogic-tv/api/common/request" at "/api/common/request.xqy";
import module namespace mem = "http://xqdev.com/in-mem-update" at "/MarkLogic/appservices/utils/in-mem-update.xqy";

declare default element namespace "http://marklogic.com/xdmp/json/basic";
declare namespace d="http://marklogic.com/xdmp/json/basic";

declare function create($id as xs:string, $collections as xs:string*) as element() {
  let $body := $request:get-body()
  let $body :=  json:transform-from-json($request:get-body())
  let $body := mem:node-insert-child($body/*, <created-at type="string">{fn:current-dateTime()}</created-at>)
  let $insert := xdmp:document-insert($id, $body, (), $collections)
  return $body
};

